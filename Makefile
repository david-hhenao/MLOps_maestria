install:
pip install --upgrade pip &&\
pip install -r requirements.txt
format:
black *.py
train:
python train.py
eval:
echo "## Model Metrics" > report.md
cat ./Results/metrics.txt >> report.md
echo '\n## Confusion Matrix Plot' >> report.md
echo '![Confusion Matrix](./Results/model_results.png)' >> report.md
cml comment create report.md
update-branch:
git config --global user.name $(USER_NAME)
git config --global user.email $(USER_EMAIL)
git commit -am "Update with new results"
git push --force origin HEAD:update
hf-login:
pip install -U "huggingface_hub[cli]"
git pull origin main
git switch main
huggingface-cli login --token $(HF_TOKEN) --add-to-git-credential
push-hub:
huggingface-cli upload david-hhenao/MLOps_maestria_space ./App --repo-type=space --commit-message="Sync App files"
huggingface-cli upload david-hhenao/MLOps_maestria_space ./Model /Model --repo-type=space --commit-message="Sync Model"
huggingface-cli upload david-hhenao/MLOps_maestria_space ./Results /Metrics --repo-type=space --commit-message="Sync Model"
deploy: hf-login push-hub
all: install format train eval update-branch deploy