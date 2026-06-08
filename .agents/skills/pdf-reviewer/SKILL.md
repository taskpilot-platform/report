---
name: pdf-reviewer
description: 'Review PDF outputs for visual anomalies such as overflowing tables, blank images, or misaligned elements. Use when: (1) After generating or compiling a PDF, (2) User asks to verify the layout or formatting.'
---

# PDF Reviewer

This skill provides a systematic approach for an agent to visually verify PDF documents to ensure high-quality typesetting and layout. Because the agent has multimodal capabilities, it can "read" the PDF visually.

## Process

1. **Compile the Document**: Ensure the latest version of the document is compiled to a `.pdf` file.
2. **View the PDF**: Use the `view_file` tool on the `.pdf` file. The tool automatically converts the PDF pages into images so you can visually inspect them.
3. **Analyze Tables**: Scan the pages for tables and check for:
   - **Text Overflow**: Does any text (especially long identifiers, code blocks, or URLs) spill out of the column boundaries?
   - **Pagination Issues**: Does a table break poorly across pages without repeating headers?
   - **Alignment**: Are columns properly aligned and proportionate?
4. **Analyze Images/Figures**: Scan for figures and check for:
   - **Blank/Empty Images**: Are there any figures that rendered completely white or missing? (This often happens with unsupported SVG elements).
   - **Clipping**: Is the image cut off at the margins?
   - **Proportions**: Are the images stretched or squeezed unnaturally?
5. **General Layout**: Check for:
   - **Orphans/Widows**: Single lines of text left alone at the top or bottom of a page.
   - **Overlapping Elements**: Text or images overlapping each other.
   - **Placeholders**: Are there any `TODO` blocks or placeholder rectangles left over?

## Tools to use
- `view_file` on the `output.pdf`. This is the ONLY way the agent can visually inspect the formatting.

## Reporting
After visually scanning the PDF, report back to the user with a structured list of anomalies found. Be specific about the page number, the element (e.g., "Bảng 3.1", "Hình 4.2"), and the nature of the issue. If no anomalies are found, confirm that the formatting looks solid and clean.
