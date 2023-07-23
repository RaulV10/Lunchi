import sys
import json
from io import BytesIO
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer

def generate_pdf(title, ingredients, steps, time):
    # Convert JSON strings to Python lists
    ingredients_list = json.loads(ingredients)
    steps_list = json.loads(steps)

    # Create a buffer to store the PDF data
    buffer = BytesIO()

    # Create a PDF document
    doc = SimpleDocTemplate(buffer, pagesize=letter)
    styles = getSampleStyleSheet()

    # Add content to the PDF
    elements = []
    elements.append(Paragraph(title, styles['Title']))
    elements.append(Spacer(1, 12))
    elements.append(Paragraph("Estimate Preparation Time: " + "<b>" + time + "</b>", styles['Normal']))
    elements.append(Spacer(1, 12))
    elements.append(Paragraph("Ingredients:", styles['Heading2']))
    for ingredient in ingredients_list:
        elements.append(Paragraph(ingredient, styles['Normal']))
    elements.append(Spacer(1, 12))
    elements.append(Paragraph("Steps:", styles['Heading2']))
    for step in steps_list:
        elements.append(Paragraph(step, styles['Normal']))

    # Build the PDF
    doc.build(elements)

    # Get the PDF data as a byte array
    pdf_data = buffer.getvalue()
    buffer.close()

    # Write the PDF data to stdout
    sys.stdout.buffer.write(pdf_data)

if __name__ == "__main__":
    if len(sys.argv) == 5:
        title = sys.argv[1]
        ingredients = sys.argv[2]
        steps = sys.argv[3]
        time = sys.argv[4]
        generate_pdf(title, ingredients, steps, time)
