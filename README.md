
# FlexIt Docker Deployment

This repository provides everything needed to deploy [FlexIt](https://flexitanalytics.com/) using Docker.
FlexIt is a highly powerful and flexible business intelligence and data transformation tool.

---

## Installation Instructions

### 1. Configure Environment Variables

The repo's `.env` file defines project-level variables. Should you need to update ports or install versions, you can edit them there. Otherwise keep the defaults.

```dotenv
## -- frontend app setup -- ##
FLEXIT_PORT=3030
FLEXIT_VERSION=latest

## -- backend db setup -- ##
CONTENT_DB_VERSION=latest
DB_PORT=5432
```

### 2. Install The Software

In an **administrator** powershell session, run `.\install.cmd`.
This will install the needed software and allow you to configure the backend credentials. 

The application will automatically start after this script is complete. 
You may need to reboot the server if docker was not previously installed.

### 3. Start the Application

call the below start script to start the application
```bash
./scripts/start_server.sh
```
or on windows
```bash
./scripts/start_server.bat
```

### 3. Access FlexIt
Visit the application at:
- **First Install**: `http://localhost:<FLEXIT_PORT>`
- **After Optionally Configuring SSL (below)**: `https://DNS_NAME`

---

## Configuring the application for production use

### Configure SSL

1. Provide a certificate and key file. These files should be placed in a `certs` folder in the `flex_config` directory.
- The files should be named `certificate.pem` and `privatekey.pem`.

> [!NOTE] 
> You will have to restart the application after adding the certificate and key files.

```sh
./scripts/restart_server.sh
# or
docker compose down
docker compose up -d
```

After restarting the server, an administrator can navigate to Configuration > Server Settings and add the Host Name, as well as change the port to 443 and enable ssl.

![Server Settings](https://github.com/user-attachments/assets/1b2399d6-2a88-4fd4-b125-d531654ab08a)


![SSL Settings](https://github.com/user-attachments/assets/3fe63d24-f5f0-40d9-b817-c8e21eb16d21)

3. Update the `FLEXIT_PORT` in `.env` to use port 443.

```dotenv
## -- frontend app setup -- ##
FLEXIT_PORT=443
```
4. Restart the application again.

```sh 
./scripts/restart_server.sh
# or
docker compose down
docker compose up -d
```

5. Access the application at `https://<dns_name_in_settings>`.

---

## Additional Notes

### Viewing Logs
To view logs for the FlexIt Frontend:
```bash
docker logs flexit-analytics  # container logs
docker exec -it flexit-analytics sh -c 'tail -f $(ls -t /opt/flexit/logs/flexit_*.log | head -n 1)'  # most recent application log file
```

To view logs for the FlexIt Backend:
```bash
docker logs flexit-content-database  # container logs
```

### Stopping the Application
To stop the application:

```bash
./scripts/stop_server.bat
```

### Restarting the Application
To restart the application:

```bash
./scripts/restart_server.bat
```

---

## Troubleshooting
### 1. FlexIt Frontend Not Starting
- Ensure docker is running:
  ```bash
  docker ps
  ```
- Review logs:
  ```bash
  docker logs flexit-analytics
  ```

