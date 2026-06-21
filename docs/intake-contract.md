📘 PROCESSLIFT INTAKE CONTRACT (v1.0)
Author: David (Solutions Architect)
System: ProcessLift Intake Pipeline
Scope: Elementor → n8n → Supabase → AI → Lead Scoring
Status: Active, Living Document

1. Purpose of This Contract
The Intake Contract defines the data lifecycle for all information entering the ProcessLift system.

It ensures:

Consistency across frontend, automation, and database

Predictable behavior as the system evolves

Prevention of schema drift

Clean, validated, structured data for AI and scoring

A single source of truth for all intake‑related decisions

This contract is updated any time the intake form, automation logic, or database schema changes.

2. Field Definitions (Authoritative List)
Each field includes:

Purpose

Expected format

Required/optional status

Validation rules

Transformation rules

Storage mapping

Future usage notes

2.1 Contact Information
company
Purpose: Identify the client organization

Type: text

Required: Yes

Validation: Non‑empty

Transform: Trim whitespace

Storage: pl_intakes.company

Usage: Lead scoring, AI context, CRM

contact_name
Purpose: Primary contact person

Type: text

Required: Yes

Validation: Non‑empty

Transform: Title‑case

Storage: pl_intakes.contact_name

Usage: Communication, personalization

email
Purpose: Contact email

Type: text

Required: Yes

Validation: Must contain “@” and domain

Transform: Lowercase, trim

Storage: pl_intakes.email

Usage: Notifications, CRM, deduplication

phone
Purpose: Contact phone number

Type: text

Required: Yes

Validation: Must be 10 digits

Transform: Normalize → (xxx) xxx‑xxxx

Storage: pl_intakes.phone

Usage: Sales follow‑up, scoring

2.2 Operational Data
team_size
Purpose: Company size indicator

Type: text

Required: No

Validation: None

Transform: Trim

Storage: pl_intakes.team_size

Usage: Lead scoring (company_size_score)

industry
Purpose: Industry classification

Type: text

Required: No

Validation: None

Transform: Trim

Storage: pl_intakes.industry

Usage: AI classification, workflow recommendations

current_tools
Purpose: Tools currently used by the client

Type: text

Required: No

Validation: None

Transform: Trim

Storage: pl_intakes.current_tools

Usage: Integration mapping, AI analysis

systems_used
Purpose: Systems/platforms in use

Type: text

Required: No

Validation: None

Transform: Trim

Storage: pl_intakes.systems_used

Usage: AI workflow mapping

2.3 Pain & Goal Data
workflow_pains
Purpose: Client’s top workflow challenges

Type: text

Required: Yes

Validation: Non‑empty

Transform: Trim

Storage: pl_intakes.workflow_pains

Usage:

AI intent classification

Lead scoring (pain_score)

Workflow recommendations

workflow_goals
Purpose: Desired outcomes

Type: text

Required: Yes

Validation: Non‑empty

Transform: Trim

Storage: pl_intakes.workflow_goals

Usage:

AI recommendations

Lead scoring (intent_score)

2.4 Metadata Fields
form_type
Purpose: Identify which form submitted the data

Type: text

Required: Yes (hidden)

Default: intake

Storage: pl_intakes.form_type

Usage: Multi‑form support

form_version
Purpose: Track schema version

Type: text

Required: Yes (hidden)

Default: 1.0

Storage: pl_intakes.form_version

Usage: Backward compatibility

source_url
Purpose: Page where form was submitted

Type: text

Required: No

Storage: pl_intakes.source_url

Usage: Debugging, analytics

utm_source / utm_medium / utm_campaign
Purpose: Marketing attribution

Type: text

Required: No

Storage: pl_intakes.utm_*

Usage: Attribution, analytics

3. Validation Rules (n8n)
Required Fields
company

contact_name

email

phone

workflow_pains

workflow_goals

Email Validation
Regex:
/.+@.+\..+/

Phone Validation
Strip non‑digits

Must be 10 digits

Text Fields
Trim whitespace

Remove leading/trailing line breaks

4. Transformation Rules
phone
Input: "8645551234"

Output: "(864) 555‑1234"

email
Lowercase

Trim

contact_name
Convert to Title Case

All text fields
Trim whitespace

5. n8n → Supabase Mapping Plan
Form Field	n8n Variable	Supabase Column
company	{{$json.company}}	pl_intakes.company
contact_name	{{$json.contact_name}}	pl_intakes.contact_name
email	{{$json.email}}	pl_intakes.email
phone	{{$json.phone_formatted}}	pl_intakes.phone
team_size	{{$json.team_size}}	pl_intakes.team_size
industry	{{$json.industry}}	pl_intakes.industry
workflow_pains	{{$json.workflow_pains}}	pl_intakes.workflow_pains
workflow_goals	{{$json.workflow_goals}}	pl_intakes.workflow_goals
current_tools	{{$json.current_tools}}	pl_intakes.current_tools
systems_used	{{$json.systems_used}}	pl_intakes.systems_used
source_url	{{$json.source_url}}	pl_intakes.source_url
form_type	{{$json.form_type}}	pl_intakes.form_type
form_version	{{$json.form_version}}	pl_intakes.form_version
utm_source	{{$json.utm_source}}	pl_intakes.utm_source
utm_medium	{{$json.utm_medium}}	pl_intakes.utm_medium
utm_campaign	{{$json.utm_campaign}}	pl_intakes.utm_campaign


6. Data Types & Constraints (Supabase)
Column	Type	Nullable	Default
id	uuid	NO	gen_random_uuid()
created_at	timestamptz	YES	now()
company	text	YES	null
contact_name	text	YES	null
email	text	YES	null
phone	text	YES	null
team_size	text	YES	null
industry	text	YES	null
workflow_pains	text	YES	null
workflow_goals	text	YES	null
current_tools	text	YES	null
systems_used	text	YES	null
source_url	text	YES	null
form_type	text	YES	null
form_version	text	YES	null
utm_source	text	YES	null
utm_medium	text	YES	null
utm_campaign	text	YES	null
status	text	YES	'new'


7. Future‑Proofing Notes
AI Classification
workflow_pains and workflow_goals feed into pl_intent_classification.

Lead Scoring
team_size, workflow_pains, workflow_goals, and industry feed into pl_lead_scores.

Multi‑Form Support
form_type allows multiple intake forms to share the same backend.

Schema Evolution
form_version ensures backward compatibility.

8. Change Management Rules
This contract must be updated when:

A field is added, removed, or renamed

A validation rule changes

A transformation rule changes

A new Supabase column is added

A new automation branch is added

A new AI analysis step is added

This is a living document.
