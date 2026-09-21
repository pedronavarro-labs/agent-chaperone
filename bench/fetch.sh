#!/usr/bin/env bash
# Download the public datasets and the benign "discusses injection" documents.
# Nothing here is redistributed with the repository; run this before build_sets.py.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p data/injecagent data/bipia data/deepset data/discusses

# InjecAgent revision: f19c9f2c79a41046eb13c03c51a24c567a8ffa07
IA=https://raw.githubusercontent.com/uiuc-kang-lab/InjecAgent/f19c9f2c79a41046eb13c03c51a24c567a8ffa07/data
for f in user_cases.jsonl attacker_cases_dh.jsonl attacker_cases_ds.jsonl; do
  curl -fsSL "$IA/$f" -o "data/injecagent/$f"
done

# BIPIA datasets and README revision: a004b69ec0dd446e0afd461d98cb5e96e120a5d0
BIPIA=https://raw.githubusercontent.com/microsoft/BIPIA/a004b69ec0dd446e0afd461d98cb5e96e120a5d0/benchmark
curl -fsSL "$BIPIA/email/test.jsonl" -o data/bipia/email_test.jsonl
curl -fsSL "$BIPIA/text_attack_test.json" -o data/bipia/text_attack_test.json

# The datasets-server rows endpoint remains live; see README.md (Source revisions).
DS='https://datasets-server.huggingface.co/rows?dataset=deepset%2Fprompt-injections&config=default&split=test'
curl -fsSL "$DS&offset=0&length=100" -o data/deepset/rows_test_0.json
curl -fsSL "$DS&offset=100&length=100" -o data/deepset/rows_test_100.json

# OWASP revision: 99f4395589bdbd120ae961f9cd179e79d7f9b27f
curl -fsSL https://raw.githubusercontent.com/OWASP/www-project-top-10-for-large-language-model-applications/99f4395589bdbd120ae961f9cd179e79d7f9b27f/2_0_vulns/LLM01_PromptInjection.md -o data/discusses/owasp-llm01.md
# Wikipedia revision: 1370277088 (2026-08-20).
curl -fsSL 'https://en.wikipedia.org/w/index.php?title=Prompt_injection&oldid=1370277088&action=raw' -o data/discusses/wikipedia-prompt-injection.txt
# TypeSafe remains live: no immutable public source identified; see README.md.
curl -fsSL https://docs.typesafe.ai/cookbooks/llm_guardrails.md -o data/discusses/typesafe-guardrails.md
# AgentDojo revision: 089ed468cf3ed0322acc66b0211f26d9d90dbf60
curl -fsSL https://raw.githubusercontent.com/ethz-spylab/agentdojo/089ed468cf3ed0322acc66b0211f26d9d90dbf60/README.md -o data/discusses/agentdojo-readme.md
curl -fsSL https://raw.githubusercontent.com/microsoft/BIPIA/a004b69ec0dd446e0afd461d98cb5e96e120a5d0/README.md -o data/discusses/bipia-readme.md
# Promptfoo revision retained from #70: d1aa582c9d799d4c04c32ad4dd3e35effbbd2114.
curl -fsSL https://raw.githubusercontent.com/promptfoo/promptfoo/d1aa582c9d799d4c04c32ad4dd3e35effbbd2114/site/docs/red-team/plugins/indirect-prompt-injection.md -o data/discusses/promptfoo-indirect-prompt-injection.md

wc -c data/*/* | tail -1
