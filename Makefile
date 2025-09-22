start-minikube:
	minikube start --cpus=4 --memory=6g --kubernetes-version=stable
	minikube addons enable ingress    # if you want to use the Ingress above

build:
	eval $(minikube docker-env) && docker build -t hello-fastapi:0.1.0 ./app

install-argocd:
	kubectl create namespace argocd
	kubectl apply -n argocd \
      -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

wait-for-argocd:
	kubectl -n argocd get pods

login-to-argocd:
	kubectl -n argocd port-forward svc/argocd-server 8080:443

argocd-password:
	kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 -d; echo

register-app-in-argocd:
	kubectl apply -f argo/app.yaml

tunel-to-app:
	kubectl -n argocd port-forward svc/hello 8000:80
	# then curl http://localhost:8000/
