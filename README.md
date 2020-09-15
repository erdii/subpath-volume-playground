### playground for fiddling around with `subPath` volume mounts and podpresets

- run `make kind-create-cluster` to create a kind cluster with podpresets enabled

- [./static](./static) works fine
  - static configmap mounts are defined directly in the deployment
  - the same confimap is mounted multiple times with the `subPath` key
    - single keys are taken out of the configmap and projected into the target folder while still keeping existing files in the folder
    - behavior without `subPath` would be: override/shadow target folder on mount

- [./podpreset-single](./podpreset-single) works fine
  - a podpreset is used to inject a a volume and a volumeMount into pods
  - `subPath` can be used

- [./podpreset-multi](./podpreset-multi) doesn't work
  - a podpreset is used to inject a a volume and multiple volumeMounts into pods
  - apparently podpreset thinks there can only be 1 volumeMount for 1 volume:
    ```
W0915 09:24:52.545339       1 admission.go:147] conflict occurred while applying podpresets: ca-injector on pod: test-7dd5c6d7b7- err: [merging volume mounts for ca-injector has a conflict on root-cas: 
v1.VolumeMount{Name:"root-cas", ReadOnly:false, MountPath:"/etc/ssl/certs/foo.txt", SubPath:"foo.txt", MountPropagation:(*v1.MountPropagationMode)(nil), SubPathExpr:""}
does not match
core.VolumeMount{Name:"root-cas", ReadOnly:false, MountPath:"/etc/ssl/certs/letsencrypt-staging-ca.crt", SubPath:"letsencrypt-staging-ca.crt", MountPropagation:(*core.MountPropagationMode)(nil), SubPathExpr:""}
 in container, merging volume mounts for ca-injector has a conflict on root-cas: 
v1.VolumeMount{Name:"root-cas", ReadOnly:false, MountPath:"/etc/ssl/certs/bar.txt", SubPath:"bar.txt", MountPropagation:(*v1.MountPropagationMode)(nil), SubPathExpr:""}
does not match
core.VolumeMount{Name:"root-cas", ReadOnly:false, MountPath:"/etc/ssl/certs/letsencrypt-staging-ca.crt", SubPath:"letsencrypt-staging-ca.crt", MountPropagation:(*core.MountPropagationMode)(nil), SubPathExpr:""}
 in container]
    ```
