import anthropic
import json
import os
from detector_unattached_disks import UnattachedDiskDetector
 
 
SYSTEM_PROMPT = """You are an SRE AI agent that analyses cloud infrastructure issues
and decides the best remediation action.
 
For each issue provided, return a JSON object with:
- issue_id: matching the input id
- root_cause: brief explanation of why this issue exists
- fix_action: specific action to take (e.g. "delete_disk", "resize_vm", "patch_firewall")
- fix_type: either "crossplane" (infra-level, needs provisioning change)
            or "kubectl" (runtime-level, needs k8s API call)
- risk_level: LOW, MEDIUM, or HIGH (risk of applying this fix automatically)
- confidence: 0-100 (how confident you are this is the correct fix)
- estimated_impact: human readable summary of savings or risk reduction
- crossplane_yaml: if fix_type is crossplane, provide the exact YAML to apply.
                    Use apiVersion compute.gcp.upbound.io/v1beta1 for disk resources.
                    For deletion, omit yaml and just describe the kubectl/gcloud delete command instead.
 
Respond ONLY with a JSON array, no other text, no markdown formatting."""
 
 
def analyse_issues(issues: list[dict]) -> list[dict]:
    if not issues:
        return []
 
    client = anthropic.Anthropic()
 
    issues_text = json.dumps(issues, indent=2)
 
    response = client.messages.create(
        model="claude-sonnet-4-6",
        max_tokens=2000,
        system=SYSTEM_PROMPT,
        messages=[{
            "role": "user",
            "content": f"Analyse these infrastructure issues and provide fixes:\n\n{issues_text}"
        }]
    )
 
    raw_text = response.content[0].text.strip()
 
    # Clean up in case model wraps in markdown fences
    if raw_text.startswith("```"):
        raw_text = raw_text.split("```")[1]
        if raw_text.startswith("json"):
            raw_text = raw_text[4:]
 
    try:
        return json.loads(raw_text)
    except json.JSONDecodeError as e:
        print(f"Failed to parse Claude response: {e}")
        print(f"Raw response:\n{raw_text}")
        return []
 
 
if __name__ == "__main__":
    print("Detecting issues...")
    detector = UnattachedDiskDetector()
    issues = detector.detect()
    print(f"Found {len(issues)} issue(s)\n")
 
    if not issues:
        print("No issues to analyse.")
        exit()
 
    print("Sending to Claude for analysis...\n")
    fixes = analyse_issues(issues)
 
    print("AI Recommended Fixes:\n")
    print(json.dumps(fixes, indent=2))
