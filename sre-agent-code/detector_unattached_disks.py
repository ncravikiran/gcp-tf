import subprocess
import json
from datetime import datetime
 
class UnattachedDiskDetector:
    """Detects GCP persistent disks that are not attached to any VM."""
 
    def detect(self) -> list[dict]:
        issues = []
 
        result = subprocess.run([
            "gcloud", "compute", "disks", "list",
            "--filter=NOT users:*",
            "--format=json"
        ], capture_output=True, text=True)
 
        if result.returncode != 0:
            print(f"Error running gcloud: {result.stderr}")
            return issues
 
        disks = json.loads(result.stdout) if result.stdout.strip() else []
 
        for disk in disks:
            size_gb = int(disk.get("sizeGb", 0))
            monthly_cost = round(size_gb * 0.04, 2)  # approx $0.04/GB/month
 
            issues.append({
                "id": f"disk-unattached-{disk['name']}",
                "source": "gcp-compute",
                "category": "UNATTACHED_DISK",
                "severity": "MEDIUM",
                "resource": disk["selfLink"],
                "description": f"Disk '{disk['name']}' ({size_gb}GB) is unattached",
                "metadata": {
                    "disk_name": disk["name"],
                    "size_gb": size_gb,
                    "monthly_waste_usd": monthly_cost,
                    "zone": disk.get("zone", "").split("/")[-1] if disk.get("zone") else None,
                    "self_link": disk["selfLink"]
                },
                "detected_at": datetime.utcnow().isoformat()
            })
 
        return issues
 
 
if __name__ == "__main__":
    detector = UnattachedDiskDetector()
    issues = detector.detect()
 
    print(f"\nFound {len(issues)} unattached disk(s)\n")
    print(json.dumps(issues, indent=2))
