# DVC Workflow Guide

This project uses **DVC (Data Version Control)** to version large datasets while
keeping GitHub lightweight.

- **git**  = code + tiny `.dvc` pointer files  → GitHub
- **dvc**  = the actual dataset bytes          → DVC remote (`/home/ubuntu/DVC`)

> **Golden rule:** `git` and `dvc` travel together.
> Always `upload` both, always `download` both.

## Helper scripts

| Script | What it does | When to run |
|---|---|---|
| `./version_data.sh <folder> "msg"` | `dvc add` + `git commit` — makes a new dataset version | after the dataset changes, or to track a new dataset |
| `./upload_data.sh` | `git push` + `dvc push` — back up code + data | after versioning |
| `./download_data.sh` | `git pull` + `dvc pull` — restore code + data | fresh machine / after teammate pushes |
| `./check_status.sh` | git + dvc status, and backup check | anytime |

---

## The 6 scenarios

### 1. Just TRAIN a model — (nothing DVC to do)
The data is real files on disk. Just run training:
```bash
python train.py        # or ./run_training.sh
```

### 2. The dataset CHANGED (added / removed / relabeled files)
```bash
./version_data.sh 06-07-26_cumi "Added 500 new helmet images"
./upload_data.sh
```

### 3. ADD a NEW dataset
```bash
./version_data.sh 06-07-26_airport "Track airport dataset"
./upload_data.sh
```

### 4. Go BACK to an older dataset version
```bash
git log --oneline            # find the commit you want
git checkout <commit-id>     # switch pointer to that version
dvc checkout                 # DVC rebuilds that exact data
# return to latest:
git checkout main && dvc checkout
```

### 5. Set up on a NEW machine / teammate
```bash
git clone https://github.com/Gowthamvarma6636/dvc-testing.git
cd dvc-testing
./download_data.sh           # git pull + dvc pull
```
> Note: the current DVC remote is a local folder (`/home/ubuntu/DVC`) that only
> exists on this server. For another machine to pull, switch to a cloud remote
> (S3 / Google Drive).

### 6. CHECK the status anytime
```bash
./check_status.sh
```
