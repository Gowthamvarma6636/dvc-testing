from ultralytics import YOLO
import torch


def main():
    # ==========================================
    # CHECK GPU
    # ==========================================
    print("CUDA Available:", torch.cuda.is_available())

    if torch.cuda.is_available():
        print("GPU:", torch.cuda.get_device_name(0))

    # ==========================================
    # RESUME
    #
    # The 06-07-26_cumi run was interrupted at epoch 111/120 (the tail
    # got cut off, not an early-stop -- mAP50-95 was still inching up and
    # patience=10 never triggered). It did NOT overfit this time: the
    # cos_lr fix held val/cls_loss flat at ~0.35 and mAP50 at ~0.911.
    #
    # We resume from last.pt to finish the remaining epochs 112-120 with
    # the exact original settings (data, hyperparameters, project/name are
    # all read back from the checkpoint -- do NOT re-specify them or the
    # resume is rejected). This continues into the SAME run folder.
    # ==========================================
    CKPT = ("/home/ubuntu/gowtham/model_training/"
            "runs/detect/runs/06-07-26_cumi/weights/last.pt")

    model = YOLO(CKPT)
    results = model.train(resume=True)

    # ==========================================
    # VALIDATE
    # ==========================================
    metrics = model.val()
    print(metrics)


if __name__ == "__main__":
    main()
