#! /usr/bin/python3
import requests, json, urllib3, sys, os, getpass

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Variables

headers = {}
files = []


# login and store CID

def login(ctrl_url, password):
    payload = {'action': 'login',   'username': 'admin', 'password': password}
    # print(payload)
    response = requests.request("POST", ctrl_url, headers={}, data = payload, files = [], verify = False)
    print(response.json())
    cid = response.json()["CID"]
    return cid


#  Change default password

def set_controller_password(ctrl_url, private_ip, cid, password, email):
    print("Connecting to Controller")
    new_password = {'action': 'edit_account_user', 'CID': cid, 'account_name': 'admin', 'username': 'admin', 'password': password, 'what': 'password',
        'email': email , 'old_password': str(private_ip), 'new_password': password}
    set_new_password  = requests.request("POST", ctrl_url, headers=headers, data = new_password, files = files, verify=False)
    print(set_new_password.text.encode('utf8'))
    return True
    try:
        response = requests.post(url=ctrl_url, data=payload, verify=False)
        CID = response.json()["CID"]
        new_password = {'action': 'edit_account_user', 'CID': cid, 'account_name': 'admin', 'username': 'admin', 'password': password, 'what': 'password',
    'email': email , 'old_password': str(private_ip), 'new_password': password}
        set_new_password  = requests.request("POST", ctrl_url, headers=headers, data = new_password, files = files, verify=False)
        print(set_new_password.text.encode('utf8'))
        return True
    except:
        print("Unable to connect using default password....please verify the password")
        return False


########## Controller initialization

def onboard_controller(ctrl_url, account_id, cid, email):

#### Set email:

    new_email = {'action': 'add_admin_email_addr', 'CID': cid, 'admin_email': email}
    set_new_email  = requests.request("POST", ctrl_url, headers=headers, data = new_email, files = files, verify=False)
    print(set_new_email.text.encode('utf8'))

# ### New hostname:
    set_name = {'action': 'set_controller_name','CID': cid,'controller_name': "Aviatrix Controller"}
    set_hostname = requests.request("POST", ctrl_url, headers = headers, data = set_name, files = files, verify=False)
    print(set_hostname.text.encode('utf8'))


### AWS Access Account:
    aws_account = {'action': 'setup_account_profile', 'CID': cid, 'account_name': "aws-account", 'cloud_type': '1', 'account_email': email , 'aws_account_number': account_id,
'aws_iam': 'true',
'aws_role_arn': "arn:aws:iam::"+str(account_id)+":role/aviatrix-role-app",
'aws_role_ec2': 'arn:aws:iam::'+str(account_id)+':role/aviatrix-role-ec2',
'aws_access_key': ''}
    set_aws_account = requests.request("POST", ctrl_url, headers = headers, data = aws_account, files = files, verify=False)
    print("Created AWS Access Account: ", set_aws_account.text.encode('utf8'))

### Upgrade Controller
    print("Upgrading controller. It can take several minutes")
    upgrade = {'action': 'upgrade','CID': cid, 'version' : '6.0'}
    upgrade_latest = requests.request("POST", ctrl_url, headers=headers, data = upgrade, files = files, verify=False)
    print(upgrade_latest.text.encode('utf8'))


### Create txt file

def print_credentials(public_ip, email, password):
    with open("controller_settings.txt", "w+") as f:
        f.write("Controller Public IP: " + str(public_ip) + '\n')
        f.write("username: admin"  + '\n')
        f.write("password: " + str(password) + '\n')
        f.write("Recovery email: " + str(email) + '\n')

def export_password_to_envvar(password):
    print(password)
    os.environ['AVIATRIX_PASSWORD'] = password

def main():
    # public_ip = input("Enter Controller Public IP: ")
    # private_ip =  input("Enter Controller Private IP: ")
    # account_id = input("Enter AWS Account ID: ")
    public_ip = os.environ['CONTROLLER_PUBLIC_IP']
    private_ip = os.environ['CONTROLLER_PRIVATE_IP']
    account_id = os.environ['AWS_ACCOUNT']
    
    # email = input("Enter recovery email: ")
    email = os.environ['AVIATRIX_EMAIL']
    # password = getpass.getpass("Enter new password: ")
    password = os.environ['AVIATRIX_PASSWORD']
    ctrl_url = 'https://'+str(public_ip)+str("/v1/api")

    try:
        init_cid = login(ctrl_url, password=private_ip)
    except:
       print("Unable to connect to Controller: ", public_ip, "If you changed default password ingore this message.")

    set_controller_password(ctrl_url=ctrl_url, private_ip=private_ip, cid=init_cid, password=password, email=email)

    try:
        cid = login(ctrl_url, password=password)
    except:
        print("Unable to connect to Controller: ", public_ip, " Please verify new password")
        sys.exit(1)

    onboard_controller(ctrl_url=ctrl_url, account_id=account_id, cid=cid, email=email)
    # no need anymore to store those in a file.
    # print_credentials(public_ip, email, password)

if __name__ == "__main__":
    main()
