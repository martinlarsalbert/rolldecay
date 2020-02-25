import pytest
from docs import notebooks_to_presentation
import docs
import os

def test_convert_notebook_to_presentation():

    notebook_path = os.path.join(docs.path,'presentation1','presentation1.ipynb')
    markdown_path = os.path.join(docs.path,'presentation1','presentation1.md')

    notebooks_to_presentation.convert_notebook_to_presentation(notebook_path=notebook_path,markdown_path=markdown_path)