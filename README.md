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
    W0915 06:10:11.718830       1 admission.go:147] conflict occurred while applying podpresets: ca-injector on pod: test-7dd5c6d7b7- err: [merging volume mounts for ca-injector has a conflict on root-cas: 
    v1.VolumeMount{Name:"root-cas", ReadOnly:false, MountPath:"/etc/ssl/certs/vreni", SubPath:"vreni", MountPropagation:(*v1.MountPropagationMode)(nil), SubPathExpr:""}
    does not match
    core.VolumeMount{Name:"root-cas", ReadOnly:false, MountPath:"/etc/ssl/certs/joshys-custom-ca.crt", SubPath:"ca.crt", MountPropagation:(*core.MountPropagationMode)(nil), SubPathExpr:""}
    in container, merging volume mounts for ca-injector has a conflict on root-cas: 
    v1.VolumeMount{Name:"root-cas", ReadOnly:false, MountPath:"/etc/ssl/certs/foo.txt", SubPath:"foo.txt", MountPropagation:(*v1.MountPropagationMode)(nil), SubPathExpr:""}
    does not match
    core.VolumeMount{Name:"root-cas", ReadOnly:false, MountPath:"/etc/ssl/certs/joshys-custom-ca.crt", SubPath:"ca.crt", MountPropagation:(*core.MountPropagationMode)(nil), SubPathExpr:""}
    in container]
    W0915 06:21:17.280589       1 watcher.go:199] watch chan error: etcdserver: mvcc: required revision has been compacted
    I0915 06:21:53.636643       1 trace.go:116] Trace[510203119]: "Get" url:/api/v1/namespaces/kube-system/pods/kube-apiserver-kind-control-plane/log,user-agent:kubectl/v1.18.7 (linux/amd64) kubernetes/bfb38f7,client:172.18.0.1 (started: 2020-09-15 06:10:34.835732809 +0000 UTC m=+408.874015665) (total time: 11m18.800726454s):
    Trace[510203119]: [11m18.800722636s] [11m18.798946649s] Transformed response object
    I0915 06:24:27.164737       1 admission.go:154] applied podpresets: ca-injector successfully on Pod: test-7dd5c6d7b7- 
    I0915 06:26:36.602684       1 admission.go:154] applied podpresets: ca-injector successfully on Pod: test-7dd5c6d7b7- 
    I0915 06:29:06.359132       1 admission.go:154] applied podpresets: ca-injector successfully on Pod: test-7dd5c6d7b7- 
    W0915 06:30:24.885824       1 admission.go:147] conflict occurred while applying podpresets: ca-injector on pod: test-7dd5c6d7b7- err: [merging volume mounts for ca-injector has a conflict on root-cas: 
    v1.VolumeMount{Name:"root-cas", ReadOnly:false, MountPath:"/etc/ssl/certs/foo.txt", SubPath:"foo.txt", MountPropagation:(*v1.MountPropagationMode)(nil), SubPathExpr:""}
    does not match
    core.VolumeMount{Name:"root-cas", ReadOnly:false, MountPath:"/etc/ssl/certs/letsencrypt-staging-ca.crt", SubPath:"letsencrypt-staging-ca.crt", MountPropagation:(*core.MountPropagationMode)(nil), SubPathExpr:""}
     in container, merging volume mounts for ca-injector has a conflict on root-cas: 
    v1.VolumeMount{Name:"root-cas", ReadOnly:false, MountPath:"/etc/ssl/certs/bar.txt", SubPath:"bar.txt", MountPropagation:(*v1.MountPropagationMode)(nil), SubPathExpr:""}
    does not match
    core.VolumeMount{Name:"root-cas", ReadOnly:false, MountPath:"/etc/ssl/certs/letsencrypt-staging-ca.crt", SubPath:"letsencrypt-staging-ca.crt", MountPropagation:(*core.MountPropagationMode)(nil), SubPathExpr:""}
     in container]
    ```
