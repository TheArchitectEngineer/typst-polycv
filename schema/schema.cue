package polycv

// ============================================================================
// Utility Types
// ============================================================================

#Date:      string | int | null
#ExactDate: string | int | "present" | null

#SocialNetwork: {
	// Network name; must match a key in the template's profiles-config
	// (e.g. "LinkedIn", "GitHub").
	network: string
	// Handle appended to the network's URL base (e.g. "janedoe").
	username: string
}

// ============================================================================
// Entry Types
// ============================================================================

// A timeline or list entry, reused by experience, education, awards,
// volunteering and courses. Not all fields apply to every section.
#Entry: {
	// Primary title (award/course name). Alias of company for list sections.
	name?: string
	// Organisation or employer (experience). Alias: degree for education.
	company?: string
	// Job title or role, shown after the company.
	position?: string
	// Short subtitle under the title. Alias: institution for education.
	summary?: string
	// Place (city, country) shown on the right.
	location?: string
	// Start date, "YYYY-MM" or "YYYY".
	start_date?: #Date
	// End date, "YYYY-MM", "YYYY" or "present".
	end_date?: #ExactDate
	// Single date, alternative to start_date/end_date (awards, courses).
	date?: #Date
	// Bullet points; supports *bold* and _italic_ inline markup.
	highlights?: [...string]

	...
}

#PublicationEntry: {
	// Publication title.
	title: string
	// List of author names.
	authors?: [...string]
	// Short description or venue note.
	summary?: string
	// Digital Object Identifier; rendered as a doi.org link.
	doi?: string
	// Direct URL to the publication.
	url?: string
	// Journal or conference name.
	journal?: string
	// Publication date.
	date?: #Date
	...
}

#SkillGroup: {
	// Display heading. Defaults to the group's key if omitted.
	title?: string
	// FontAwesome icon name shown before the heading.
	icon?: string
	// Skills: a single string, or a list rendered one per line.
	items: string | [...string]
	...
}

#TextBlock: {
	// Section heading. Defaults to the block's key if omitted.
	title?: string
	// FontAwesome icon shown before the heading (default "circle-info").
	icon?: string
	// Free-text lines: each is a plain string (inline *bold*/_italic_ markup),
	// or {subtitle: "..."} for a bold sub-heading styled like other sections.
	lines: [...(string | {subtitle: string, ...})]
	// Render the lines as a chevron list (like hobbies) instead of plain lines.
	bulleted?: bool
	...
}

// ============================================================================
// CV Schema
// ============================================================================

#CV: {
	// Full name, shown large in the header.
	name?: string
	// Tagline under the name.
	headline?: string
	// Location line (city, country).
	location?: string
	// Tag badges shown in the header.
	keywords?: [...string]
	// Email address; a single string or a list of lines.
	email?: string | [...string]
	// Phone number; a single string or a list of lines.
	phone?: string | [...string]
	// Postal address; a single string or a list of lines.
	address?: string | [...string]
	// Summary / profile paragraph.
	summary?: string
	// Motivation paragraph (cover-letter style intro).
	motivation?: string
	// Personal values, one bullet each.
	values?: [...string]
	// Hobbies / interests, one bullet each.
	hobbies?: [...string]
	// References text, or a list of bullets.
	references?: string | [...string]
	// Social profiles (network + username).
	profiles?: [...#SocialNetwork]
	// Skill groups, keyed by a stable name (used by meta.skill-order). Add any
	// key you like; the key is the icon-independent identifier, the display
	// heading comes from each group's `title` (default: the key).
	skills?: {[string]: #SkillGroup}
	// Free-text sidebar/main blocks, keyed by name; place a block by its key
	// in sidebar-sections / main-sections.
	"text-blocks"?: {[string]: #TextBlock}
	// Professional experience entries.
	experience?: [...#Entry]
	// Education entries.
	education?: [...#Entry]
	// Honours and awards.
	awards?: [...#Entry]
	// Volunteering and community involvement entries.
	volunteering?: [...#Entry]
	// Courses and certifications.
	courses?: [...#Entry]
	// Publications.
	publications?: [...#PublicationEntry]
}

// Section keys usable in sidebar-sections / main-sections (either column).
#SectionName: "photo" | "contact" | "skills" | "values" | "hobbies" |
	"references" | "publications" | "summary" | "motivation" |
	"experience" | "education" | "awards" | "volunteering" | "courses"

// Layout/config block; consumed by the template, not part of the CV data.
#CvMeta: {
	// Path to the profile photo, relative to the .typ file.
	photo?: string
	// Diameter of the circular photo as a percent of the sidebar width.
	"photo-size"?: int & >=0
	// Language for section titles and month names.
	locale?: "en" | "fr"
	// Header/column layout: "basic" (simple header), "ats-split" (two-column
	// ATS-friendly header) or "header-band" (full-width band, photo on its left).
	"layout"?: "basic" | "ats-split" | "header-band"
	// Render the summary inside the header (any layout) instead of as a
	// main-column section.
	"summary-in-header"?: bool
	// Render the contact line in the header area (any layout) instead of the
	// sidebar.
	"contact-in-header"?: bool
	// Page paper size (default "a4").
	"paper"?: "a4" | "us-letter"
	// Hyphenate justified text (default true; false avoids mid-word breaks).
	"hyphenate"?: bool
	// Scale text and spacing (default 1.0); smaller values shrink fonts and
	// gaps within fixed margins, fitting more content per line and per page.
	"scale"?: number & >0
	// Company + location/dates on the title line, position below.
	"entry-inline-meta"?: bool
	// Show the dots + vertical line on experience/education entries.
	"show-timeline"?: bool
	// Number of right-aligned lines for keyword badges (0 = one per line).
	"keywords-lines"?: int & >=0
	// Ordered sidebar section keys (a built-in SectionName or a text-block key).
	"sidebar-sections"?: [...string]
	// Ordered main-column section keys (a built-in SectionName or a block key).
	"main-sections"?: [...string]
	// Override section display titles, keyed by section name.
	"section-titles"?: {[#SectionName]: string}
	// Override section FontAwesome icons, keyed by section name.
	"section-icons"?: {[#SectionName]: string}
	// Which skill groups to show, in order, by their key in cv.skills. Omit a
	// key to hide that group. If unset, all groups render in their data order.
	"skill-order"?: [...string]
}

#CVSchema: {
	// Path (relative to this file) of a parent CV to deep-merge over.
	inherit?: string
	cv:       #CV
	meta?:    #CvMeta
}

// ============================================================================
// Letter Schema
// ============================================================================

#Sender: {
	// Sender's full name.
	name: string
	// Sender's phone number.
	phone?: string
	// Sender's email address.
	email?: string
	// LinkedIn handle.
	linkedin?: string
	// GitHub handle.
	github?: string
	// Sender's postal address.
	address?: string
}

#Recipient: {
	// Recipient's name.
	name?: string
	// Recipient's job title.
	title?: string
	// Recipient's company.
	company?: string
	// Recipient's postal address.
	address?: string
}

#BodyParagraph: {
	// One letter paragraph; supports inline markup.
	paragraph: string
}

#Content: {
	// Subject line, shown as "Re: ...".
	subject?: string
	// Opening salutation.
	salutation?: string
	// Closing phrase before the signature.
	closing?: string
	// Letter body paragraphs.
	body?: [...#BodyParagraph]
}

#Metadata: {
	// Letter date; a display string or "auto" for today.
	date?: string | "auto"
	// Letter language: "en" (default) or "fr" (subject label + auto date).
	locale?: "en" | "fr"
	// Header style: "basic" (tinted band) or "header-band" (clean, no tint).
	layout?: "basic" | "header-band"
	// Show the page footer (default true); false drops it, e.g. when the
	// contact details already appear in the header.
	footer?: bool
}

#Letter: {
	// Sender block.
	sender: #Sender
	// Recipient block.
	recipient?: #Recipient
	// Letter content (subject, salutation, body, closing).
	content: #Content
	// Letter metadata (date).
	metadata?: #Metadata
}

#LetterSchema: {
	// Path (relative to this file) of a parent letter to deep-merge over.
	inherit?: string
	letter:   #Letter
}

// ============================================================================
// Unified Schema (for JSON export)
// ============================================================================

#UnifiedSchema: {
	// Path (relative to this file) of a parent to deep-merge over.
	inherit?: string
	// CV data.
	cv?: #CV
	// Layout / configuration block.
	meta?: #CvMeta
	// Cover-letter data.
	letter?: #Letter
}
