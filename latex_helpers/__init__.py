import os

dir_path = os.path.dirname(__file__)
base_path = os.path.split(dir_path)[0]
logbook_path = os.path.join(base_path,'logbook')
paper_path = os.path.join(base_path, 'paper')
general_content_path = os.path.join(paper_path, 'general_content')
if not os.path.exists(general_content_path):
    os.mkdir(general_content_path)
