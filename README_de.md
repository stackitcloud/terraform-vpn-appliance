# STACKIT VPN Appliance Terraform Deployment
Hier enthalten sind die Deployment Scripts für Terraform.

<img width="60%" src="overview.svg">

Zum Netzwerksetup werden zwei VPC Netzwerke angelegt `vpc_network` und `wan_network` das Subnetz des VPC Netzwerks kann frei gesetzt werden. Für das WAN Network ist die Netzwerkrange `100.96.96.0/25` vorgegeben. Hierbei sollte es aber zu keinen Kollisionen kommen, da dieses Netzwerk nur für die Eingehende Verbindungen zur VPN Appliance verwendet werden.
Für jedes der beiden Netzwerke werden zusätzlich noch Router erstellt. Diese stellen zum einen eine NAT Internetverbindung her und diesen zum anderen für das Binden von FloatingIPs und das Routing der Remote VPN Netzwerke an die VPN Appliance.

Im Ornder selbst muss die Datei `.env` mit dem unten gezeigten Inhalt erstellt werden.

Konfigurations Optionen:
```console
export TF_VAR_USERNAME=<OpenStack Username>
export TF_VAR_PASSWORD=<OpenStack Password>
export TF_VAR_TENANTID=<OpenStack Project ID>
export TF_VAR_VERSION=<VPN Appliance Version>
export TF_VAR_STAGE=<(Optional) Default Prod>
export TF_VAR_REMOTE_SUBNET="<Remote Subnetwork>"
export TF_VAR_LOCAL_SUBNET="<(Optional) Default 10.0.0.0/24>"
export TF_VAR_SSH_KEY=<Public SSH Key String>
```

Die Versionen können im Image Repository abgerufen werden:
https://vpn-appliance.object.storage.eu01.onstackit.cloud/index.html

Mit der Angabe des `LOCAL` und `REMOTE` Netzwerkes, werden im OpenStack die Routen für die Netzwerkrange eingetragen.
Sollten mehrere Netzwerke geroutet werden, kann dies zum einen über eine Summenroute oder über weitere manuelle Einträge am OpenStack Router angepasst werden.

Neben den Einstellungen in der `.env` Datei können auch weitere Einstellungen in der `deployment.sh` getätigt werden.
Hier kann zum einen die zertifikatsbasierte Authentifizierung deaktiviert werden. Des Weiteren ist es auch möglich eigene Scripte einzubinden.
Zu beachten hierbei ist, das die Scripts oder Commands keine externen Abhängigkeiten haben dürfen, da nur die `deployment.sh` zum Server übertragen wird.

Weitere Einstellungen können in der `01-config.tf` vorgenommen werden.
Hier können Einstellungen wie ACL für die Verbindung per SSH oder IPsec vorgenommen werden,
die Auswahl der Availability Zone oder die VM Größe (Flavor) bestimmt werden.

### Setup:

1. Config laden:
    ```bash
    source .env
    ```
1. Terrafrom Starten
    ```bash
    terraform apply
    ```