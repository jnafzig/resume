# /// script
# dependencies = [
#   "jinja2",
#   "pyyaml",
# ]
# requires-python = ">=3.10"
# ///

"""Generate resume.tex from YAML data."""

from pathlib import Path

import yaml
from jinja2 import Environment, FileSystemLoader


def load_yaml(path):
    with open(path) as f:
        return yaml.safe_load(f)


def main():
    root = Path(__file__).parent
    data_dir = root / "_data"
    latex_dir = root / "_latex"

    config = load_yaml(root / "_config.yml")
    experience = load_yaml(data_dir / "experience.yml")
    education = load_yaml(data_dir / "education.yml")
    skills = load_yaml(data_dir / "skills.yml")
    papers = load_yaml(data_dir / "papers.yml")

    env = Environment(
        loader=FileSystemLoader(latex_dir),
        block_start_string="<%",
        block_end_string="%>",
        variable_start_string="<<",
        variable_end_string=">>",
        comment_start_string="<#",
        comment_end_string="#>",
    )
    template = env.get_template("resume.tex.j2")

    tex = template.render(
        config=config,
        experience=experience,
        education=education,
        skills=skills,
        papers=papers,
    )

    out_path = latex_dir / "resume.tex"
    out_path.write_text(tex)
    print(f"Generated {out_path}")


if __name__ == "__main__":
    main()
