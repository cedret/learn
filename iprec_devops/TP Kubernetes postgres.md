TP Kubernetes postgres
1. Déployer PostgreSQL sur un cluster Kubernetes.
2. Configurer des volumes persistants pour les données PostgreSQL.
3. Exposer PostgreSQL avec un Service.
4. Se connecter à PostgreSQL depuis un client externe pour vérifier l'installation

----------- créer namespace
----------- 
https://www.ambient-it.net/postgresql-kubernetes/

$ minikube addons enable metrics-server
$ kubectl apply -f https://raw.githubusercontent.com/reactive-tech/kubegres/v1.16/kubegres.yaml

docker ps

cedrik@cedrik-virtual-machine:~/kubernetes$ minikube start --driver=docker
cedrik@cedrik-virtual-machine:~/kubernetes$ sudo usermod -aG docker $USER && newgrp docker
cedrik@cedrik-virtual-machine:~/kubernetes$ minikube start --driver=docker
cedrik@cedrik-virtual-machine:~/kubernetes$ minikube addons enable metrics-server
kubectl apply -f https://raw.githubusercontent.com/reactive-tech/kubegres/v1.16/kubegres.yaml
docker ps
kubectl version --client
cedrik@cedrik-virtual-machine:~/kubernetes$ kubectl version --client
Client Version: version.Info{Major:"1", Minor:"21", GitVersion:"v1.21.0", GitCommit:"cb303e613a121a29364f75cc67d3d580833a7479", GitTreeState:"clean", BuildDate:"2021-04-08T16:31:21Z", GoVersion:"go1.16.1", Compiler:"gc", Platform:"linux/amd64"}
cedrik@cedrik-virtual-machine:~/kubernetes$ vim db-persistent-volume.yaml
cedrik@cedrik-virtual-machine:~/kubernetes$ vim db-volume-claim.yaml
cedrik@cedrik-virtual-machine:~/kubernetes$ vim db-configmap.yaml 
cedrik@cedrik-virtual-machine:~/kubernetes$ vim db-deployment.yaml
cedrik@cedrik-virtual-machine:~/kubernetes$ vim db-service.yaml
cedrik@cedrik-virtual-machine:~/kubernetes$ kubectl apply -f db-persistent-volume.yaml
persistentvolume/postgresdb-persistent-volume created
cedrik@cedrik-virtual-machine:~/kubernetes$ kubectl apply -f db-volume-claim.yaml
persistentvolumeclaim/db-persistent-volume-claim created
cedrik@cedrik-virtual-machine:~/kubernetes$ kubectl apply -f db-configmap.yaml
configmap/db-secret-credentials created
cedrik@cedrik-virtual-machine:~/kubernetes$ kubectl apply -f db-deployment.yaml
deployment.apps/postgresdb created
cedrik@cedrik-virtual-machine:~/kubernetes$ kubectl apply -f db-service.yaml
service/postgresdb created
cedrik@cedrik-virtual-machine:~/kubernetes$ kubectl get all
NAME                              READY   STATUS             RESTARTS         AGE
pod/postgres-7898df757b-dxjbt     0/1     CrashLoopBackOff   21 (5m10s ago)   88m..................

cedrik@cedrik-virtual-machine:~/kubernetes$ minikube dashboard
🤔  Vérification de l'état du tableau de bord...
🚀  Lancement du proxy...
🤔  Vérification de l'état du proxy...
🎉  Ouverture de http://127.0.0.1:44219/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/ dans votre navigateur par défaut.......

================== Nettoyage du dashboard avec postgres:latest qui est défectueux

kubectl delete -n default deployment postgres









http://127.0.0.1:44219/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/workloads?namespace=default
==================
cedrik@cedrik-virtual-machine:~/lamp_app/build$ kubectl create namespace postgres2
namespace/postgres2 created
cedrik@cedrik-virtual-machine:~/lamp_app/build$ kubectl get namespaces
NAME                   STATUS   AGE
default                Active   79m
kube-node-lease        Active   79m
kube-public            Active   79m
kube-system            Active   79m
kubernetes-dashboard   Active   78m
postgres2              Active   22s


================= REPONSE CHAT GPT
apiVersion: v1
kind: PersistentVolume
metadata:
  name: postgres-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /mnt/data/postgres
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:latest
          env:
            - name: POSTGRES_USER
              value: "example_user"
            - name: POSTGRES_PASSWORD
              value: "example_password"
            - name: POSTGRES_DB
              value: "example_db"
          ports:
            - containerPort: 5432
          volumeMounts:
            - name: postgres-storage
              mountPath: /var/lib/postgresql/data
      volumes:
        - name: postgres-storage
          persistentVolumeClaim:
            claimName: postgres-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: postgres-service
spec:
  selector:
    app: postgres
  ports:
    - protocol: TCP
      port: 5432
      targetPort: 5432
  clusterIP: None  # Utiliser None pour un Service sans adresse IP stable (Headless)
