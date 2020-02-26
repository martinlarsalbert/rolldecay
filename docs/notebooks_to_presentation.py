import nbformat

# 1. Import the exporter
from nbconvert import MarkdownExporter
import nbconvert.preprocessors
import nbconvert.writers
from traitlets.config import Config
import os
import shutil

class ChangeIbynbLink(nbconvert.preprocessors.Preprocessor):

    def preprocess_cell(self,cell, resources, index):
                
        if hasattr(cell,'outputs'):

            for output in cell.outputs:
                if hasattr(output,'data'):
                    if hasattr(output.data,'text/latex'):
                        output.data['text/latex'] = '$%s$' % output.data['text/latex']

        return cell, resources


def convert_notebook_to_presentation(notebook_path, markdown_path):

    notebook_filename = notebook_path
    with open(notebook_filename,encoding="utf8") as f:
        nb = nbformat.read(f, as_version=4)

    path = os.path.split(os.path.abspath(__file__))[0]
    c = Config()
    c.MarkdownExporter.preprocessors = [ChangeIbynbLink]

    # 2. Instantiate the exporter. We use the `basic` template for now; we'll get into more details
    # later about how to customize the exporter further.
    markdown_exporter = MarkdownExporter(config = c)
    markdown_exporter.template_file = os.path.join(path,'hidecode.tplx')

    # 3. Process the notebook we loaded earlier
    (body, resources) = markdown_exporter.from_notebook_node(nb)

    writer = nbconvert.writers.FilesWriter()
    writer.write(body, resources, markdown_path)

    #with open(markdown_path, 'w') as file:
    #    file.write(body)

def find_notebooks(path = ''):

    notebook_paths = []

    file_names = os.listdir(path = os.path.abspath(path))
    for file_name in file_names:
        if os.path.splitext(file_name)[-1] == '.ipynb':
            notebook_paths.append(os.path.join(path,file_name))

    return notebook_paths

def find_figures(path = ''):

    figure_paths = []

    file_names = os.listdir(path = os.path.abspath(path))
    for file_name in file_names:
        ext = os.path.splitext(file_name)[-1]
        if  ext == '.png' or ext == 'jpg':

            figure_paths.append(os.path.join(path,file_name))

    return figure_paths

def convert_notebooks(build_path = 'html',path = ''):

    notebook_paths = find_notebooks(path = path)
    figure_paths = find_figures(path = path)

    if not os.path.exists(build_path):
        os.mkdir(build_path)

    for notebook_path in notebook_paths:
        path,file_name = os.path.split(notebook_path)
        base_name = os.path.splitext(file_name)[0]
        html_file_name = '%s.html' % base_name
        html_file_path = os.path.join(build_path,html_file_name)

        convert_notebook_to_presentation(notebook_path=notebook_path, markdown_path=html_file_path)

    for figure_path in figure_paths:
        base_path,file_name = os.path.split(figure_path)
        new_path = os.path.join(build_path,file_name)
        shutil.copy(figure_path,new_path)

if __name__ == "__main__":

    convert_notebooks()



