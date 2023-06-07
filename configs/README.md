# Timoni configs

```
timoni \
    -n apps \
    build application oci://quay.io/heubeck/timoni-modules/application \
    --values configs/examiner-non-prod.cue \
  | flux push artifact \
        oci://quay.io/heubeck/timoni-instances/examiner:non-prod \
        --revision=1.0.0 \
        --source="https://github.com/heubeck/cloudland-k8s-config-timoni.git" \
        --path=-
```
