"""helper function to run as a bash code as proccess"""
import json
import re
import subprocess
import os


def error_conversion(error):
    """convert Errors return from bash to human read able string"""
    ansi_escape = re.compile(r'(?:\x1B[@-_]|[\x80-\x9F])[0-?]*[ -/]*[@-~]')
    final = ansi_escape.sub('', error)
    error_array = final.split('Error:')
    return error_array


def status_json(statename, status, state, error=None):
    """saving responce to file for last action performed"""

    # open('state.txt', 'w').close()
    # checking if file exist
    try:
        with open('state.txt') as state_file:
            data = json.load(state_file)

        if data:
            data["stateName"] = statename
            data["status"] = status
            data["state"] = state
            data["error"] = error

    except FileNotFoundError:
        data = {
            'stateName': statename,
            'status': status,
            'state': state,
            'error': error,
        }

    with open('state.txt', 'w') as outfile:
        json.dump(data, outfile)


def aws_configuration_process(key_id, secret_key):
    """Step one (aws configuration settings)"""

    status_json('awsConfiguration', 'in-progress', 1)

    # getting previous state from file
    with open('state.txt') as json_file:
        data = json.load(json_file)

    data['processedData'] = {}

    awsConfigurations = []
    awsConfigurations.append({
        'key_id': key_id,
        'secret_key': secret_key,
    })

    data['processedData'] = {'awsConfigurations': awsConfigurations}

    with open('state.txt', 'w') as outfile:
        json.dump(data, outfile)

    proc_aws = subprocess.Popen(
        ['bash', '-c', '. /root/kickstart_web.sh;'
                       ' aws_configure ' + key_id + ' ' + secret_key],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    error = proc_aws.communicate()
    if proc_aws.returncode != 0:
        errros = error_conversion(error[1].decode())
        status_json('awsConfiguration', 'failed', 1, errros)
    else:
        status_json('awsConfiguration', 'success', 1)


def aws_aviatrax_subscription(command):
    """Subscription avitrix link return"""

    proc_subscribe = subprocess.Popen(
        ['bash', '-c', '. /root/kickstart_web.sh;'
                       ' subscribe_service ' + command],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    error = proc_subscribe.communicate()
    if proc_subscribe.returncode != 0:
        errros = error_conversion(error[1].decode())
        status_json('aviatrixSubscription', 'failed', 2, errros)
    else:
        status_json('aviatrixSubscription', 'success', 2)


def launch_controller(email, recovery_email, password, confirm_password):
    """Step two (launch controller )"""

    # keeping state of control launcher
    with open('state.txt') as json_file:
        data = json.load(json_file)

    controller = []
    controller.append({
        'email': email,
        'recovery_email': recovery_email,
        'password': password,
        'confirm_password': confirm_password,
    })

    data['processedData'] = {'controller': controller,
                             'awsConfigurations': data["processedData"]["awsConfigurations"]}

    with open('state.txt', 'w') as outfile:
        json.dump(data, outfile)

    # change status
    status_json('launchController', 'in-progress', 2)
    proc_launch = subprocess.Popen(
        ['bash', '-c', '. /root/kickstart_web.sh;'
                       ' launch_controller '
         + email + ' ' + recovery_email + ' ' + password + ' ' + confirm_password],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    error = proc_launch.communicate()
    if proc_launch.returncode != 0:
        errros = error_conversion(error[1].decode())
        status_json('launchController', 'failed', 2, errros)
    else:
        status_json('launchController', 'success', 2)


def launch_controller_skip(email, password, confirm_password):
    """Step two (launch controller )"""

    # keeping state of control launcher
    with open('state.txt') as json_file:
        data = json.load(json_file)

    controller = []
    controller.append({
        'email': email,
        'password': password,
        'confirm_password': confirm_password,
    })

    data['processedData'] = {'controller': controller,
                             'awsConfigurations': data["processedData"]["awsConfigurations"]}

    with open('state.txt', 'w') as outfile:
        json.dump(data, outfile)

    # change status
    status_json('launchController', 'in-progress', 2)
    proc_launch = subprocess.Popen(
        ['bash', '-c', '. /root/kickstart_web.sh;'
                       ' controller_init '
         + email + ' ' + password + ' ' + confirm_password],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    error = proc_launch.communicate()
    if proc_launch.returncode != 0:
        errros = error_conversion(error[1].decode())
        status_json('launchController', 'failed', 2, errros)
    else:
        status_json('launchController', 'success', 2)


def launch_transit(command):
    """Step three (launch transit )"""
    if command == 'yes':
        status_json('launchAwsTransit', 'in-progress', 3)
        proc_transit = subprocess.Popen(
            ['bash', '-c', '. /root/kickstart_web.sh;'
                           ' launch_aws_transit ' + command],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        error = proc_transit.communicate()
        if proc_transit.returncode != 0:
            errros = error_conversion(error[1].decode())
            status_json('launchAwsTransit', 'failed', 3, errros)

        status_json('launchAwsTransit', 'success', 3)
    elif command == 'no':
        status_json('skipAwsTransit', 'success', 3)


def launch_aws_vpc(key):
    """Step four (aws spoke vpc launch)"""
    if key is True:
        with open('state.txt') as state_file:
            data = json.load(state_file)

        data["launchAwsSpoke"] = key

        with open('state.txt', 'w') as outfile:
            json.dump(data, outfile)

        status_json('launchAwsVpc', 'success', 4)

    elif key is False:
        status_json('skipSpokeVPC', 'success', 5)


def aws_spoke_vpc(keyname):
    """Step five (aws spoke vpc keypair)"""

    status_json('spokeVPC', 'in-progress', 5)
    proc_vpc = subprocess.Popen(
        ['bash', '-c', '. /root/kickstart_web.sh;'
                       ' mcna_aws_test_instances ' + keyname],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    error = proc_vpc.communicate()
    if proc_vpc.returncode != 0:
        errros = error_conversion(error[1].decode())
        status_json('spokeVPC', 'failed', 5, errros)
    else:
        status_json('spokeVPC', 'success', 5)


def launch_transit_azure(azure_subscription_id, azure_directory_id,
                         azure_application_id, azure_application_key):
    """Step three (launch transit )"""

    status_json('launchAzureTransit', 'in-progress', 6)
    proc_azure = subprocess.Popen(
        ['bash', '-c', '. /root/kickstart_web.sh;'
                       ' launch_azure_transit ' +
         azure_subscription_id + ' ' + azure_directory_id + ' ' +
         azure_application_id + ' ' + azure_application_key],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    error = proc_azure.communicate()
    if proc_azure.returncode != 0:
        errros = error_conversion(error[1].decode())
        status_json('launchAzureTransit', 'failed', 6, errros)

    status_json('launchAzureTransit', 'success', 6)


def aws_azure_peering(command):
    """Peering between aws and  azure"""
    if command == 'yes':
        status_json('peering', 'in-progress', 7)
        proc_peering = subprocess.Popen(
            ['bash', '-c', '. /root/kickstart_web.sh;'
                           ' transit_peering_aws_azure ' + command],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        error = proc_peering.communicate()
        if proc_peering.returncode != 0:
            errros = error_conversion(error[1].decode())
            status_json('peering', 'failed', 7, errros)

        status_json('peering', 'success', 7)
        # getting ip after whole proccess
        get_controller_ip()

    elif command == 'no':
        get_controller_ip()


def delete_resources():
    """delete resource created """

    status_json('deleteResources', 'in-progress', 0)
    proc_delete = subprocess.Popen(
        ['bash', '-c', '. /root/kickstart_web.sh;'
                       ' delete_terraform '],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    error = proc_delete.communicate()
    if proc_delete.returncode != 0:
        errros = error_conversion(error[1].decode())
        status_json('deleteResources', 'failed', 0, errros)
    else:
        try:
            os.remove('state.txt')
        except OSError:    #if file not found means file dosen't exist
            pass
        status_json('deleteResources', 'success', 0)


def get_controller_ip():
    """get IP of controller"""
    proc_ip = subprocess.Popen(
        ['bash', '-c', '. /root/kickstart_web.sh;'
                       ' get_public_ip '], stdout=subprocess.PIPE)

    result = proc_ip.communicate()[0]

    with open('state.txt') as state_file:
        data = json.load(state_file)

    data["controllerIP"] = result.decode()

    with open('state.txt', 'w') as outfile:
        json.dump(data, outfile)

    status_json('controllerIP', 'success', 8)
