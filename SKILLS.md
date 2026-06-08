---

### `SKILL.md`
```markdown
# OpenProse Skill Document Specification

This document operates directly as active system instructions. The OpenProse framework evaluates the matching semantic structures beneath each node to determine target run paths.

---

## 1. Intent: Help
* **Trigger:** `/prose help`
* **Execution Strategy:** Output system capabilities, current state configuration profile, and an inventory of sample files.

### Standard System Presentation
```text
OpenProse CLI Workflow Agent

COMMANDS:
  /prose help             Display this technical instruction overview.
  /prose run <file>       Parse and execute steps from a target path (.prose).
  /prose compile <file>   Compile readable blocks into structured JSON schema outputs.
  /prose update           Pull systemic modifications and sync active states.

EXAMPLES AVAILABLE:
  - examples/hello.prose
  - examples/pipeline.prose
2. Intent: RunTrigger: /prose run <file>Execution Strategy: Verify targeted file extensions, load code context blocks, and process sequential steps.Step Evaluation MatrixMarkdown1. READ target file from runtime filesystem boundary.
2. DISCOVER blocks matching structure markers (e.g., `---`, `Step:`, `Block:`).
3. INITIALIZE context metrics in the underlying state provider.
4. EMIT sequential progress reports to stdout or active interface context.
3. Intent: CompileTrigger: /prose compile <file>Execution Strategy: Extract structural attributes from target sources and compile clean JSON artifacts.Compilation Transformation RuleTransform markdown parameters into matching programmatic representations:Input Key-Value blocks $\rightarrow$ Nested JSON Object Attributes.Sequential descriptions $\rightarrow$ Array items containing explicitly serialized text components.4. Intent: UpdateTrigger: /prose updateExecution Strategy: Query core component updates, match schemas, and migrate local definitions cleanly.Migration Schema MatrixSource Structure VersionTarget Migration StateAction TakenLegacy Unversionedv1.0.0 Base SpecificationAuto-wrap steps into array objectsv1.0.0 Base Specificationv1.1.0 Multi-Backend StateInject backend identifier key attributes5. Bundled Program Reference LibraryFile: examples/hello.proseĐoạn mã# Hello World Program

This is an uncompiled OpenProse script verifying structural workflow functionality.

---
Step: Initialization
Action: Log tracking context parameters
Message: "Hello World from OpenProse Runtime System."
---
Step: Persistence Verification
Action: Save runtime trace parameters
Key: "sys_status"
Value: "active"
File: examples/pipeline.proseĐoạn mã# Multi-Stage Data Pipeline

---
Step: Extraction
Target: "[https://api.internal/v1/metrics](https://api.internal/v1/metrics)"
Format: "JSON"
---
Step: Transformation
Filter: "status == 'error'"
CompileTarget: "dist/errors.json"
