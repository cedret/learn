Sur un hôte **Linux Mint** (ou tout système basé sur **Ubuntu/Debian**) utilisant **KVM** avec **libvirt**, le "domaine par défaut" a deux significations possibles :

---

## 🧠 1. **Nom du réseau virtuel par défaut** — `default`

* Lorsque tu installes `libvirt`, il crée automatiquement un réseau virtuel NAT nommé `default`.
* Il attribue des IPs comme `192.168.122.0/24` aux VMs via un pont interne (NAT).

📌 Pour vérifier :

```bash
virsh net-list --all
```

Tu verras :

```
Name      State    Autostart   Persistent
--------------------------------------------
default   active   yes         yes
```

---

## 🌐 2. **Nom de domaine DNS virtuel par défaut** — `default`

Chaque réseau virtuel peut définir un domaine DNS interne pour les VMs. Par défaut, c’est souvent :

```bash
default
```

Donc les VMs auront un **FQDN** comme :

```
vm1.default
```

📌 Pour voir le domaine associé au réseau virtuel :

```bash
virsh net-dumpxml default | grep domain
```

Tu verras :

```xml
<domain name='default'/>
```

---

### 📁 Où ce domaine est-il défini ?

Dans le fichier XML de configuration réseau :

```bash
/etc/libvirt/qemu/networks/default.xml
```

Extrait :

```xml
<network>
  <name>default</name>
  <domain name='default'/>
  ...
</network>
```

---

## 💡 Modifier le domaine par défaut (ex. : `lab.local`)

Tu peux éditer le réseau virtuel :

```bash
virsh net-edit default
```

Et changer :

```xml
<domain name='default'/>
```

En :

```xml
<domain name='lab.local'/>
```

Puis redémarrer le réseau :

```bash
virsh net-destroy default
virsh net-start default
```

---

## ✅ Résumé

| Élément               | Valeur par défaut  |
| --------------------- | ------------------ |
| Nom du réseau virtuel | `default`          |
| Domaine DNS interne   | `default`          |
| Sous-réseau IP (NAT)  | `192.168.122.0/24` |

---

Souhaites-tu :

* Que les VMs utilisent un domaine personnalisé comme `vm1.lab.local` ?
* Ou que les noms de VMs soient résolus automatiquement depuis l’hôte ?

Je peux t’aider à configurer ça avec `dnsmasq`, `libvirt` ou Avahi selon le cas.
