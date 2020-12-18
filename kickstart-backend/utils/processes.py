"""helper function to run as a bash code as proccess"""
import json
import os
import re
import subprocess

from .process_utils import (controller_file_change,
                            mcna_file_change_aws,
                            mcna_file_change_azure)


def error_conversion(error):
    """convert Errors return from bash to human read able array"""
    ansi_escape = re.compile(r'(?:\x1B[@-_]|[\x80-\x9F])[0-?]*[ -/]*[@-~]')
    final = ansi_escape.sub('', error)
    error_array = final.split('Error:')
    return error_array


def output_conversion_byline(error):
    """convert Errors return from bash to human read able string"""
    ansi_escape = re.compile(r'(?:\x1B[@-_]|[\x80-\x9F])[0-?]*[ -/]*[@-~]')
    final = ansi_escape.sub('', error)
    return final


def proccess(command, state, stateName):
    """Creating proccess from here generically"""
    status_json(stateName, 'in-progress', state)
    with subprocess.Popen(command,
                          stdout=subprocess.PIPE, stderr=subprocess.PIPE, bufsize=1,
                          universal_newlines=True) as proccess:

        previous_lines = list()
        progress = []
        for line in proccess.stdout:
            previous_lines.append(output_conversion_byline(line))
            progress = ''.join(previous_lines[-30:])
            status_json(stateName, 'in-progress', state, None, progress)
            print(progress, end='')

        error = proccess.communicate()
        exit_code = proccess.wait()
        print(exit_code)
        if exit_code != 0:
            errors = error_conversion(error[1])
            status_json(stateName, 'failed', state, errors, progress)
            return 1
        else:
            status_json(stateName, 'success', state, None, progress)
            return 0


def launch_transit_state(command):
    """state update transit helper function"""
    with open('state.txt') as json_file:
        data_transit = json.load(json_file)

        launchAviatrixTransit = {
            'state': command,
        }
        data_transit['processedData'].update({'launchAviatrixTransit': launchAviatrixTransit})

        with open('state.txt', 'w') as outfile:
            json.dump(data_transit, outfile)


def launch_azure_state(command):
    """peering between azure and aws"""

    with open('state.txt') as json_file:
        data = json.load(json_file)

    avaitrixTransitAzure = {
        'state': command,
    }
    data['processedData'].update({'avaitrixTransitAzure': avaitrixTransitAzure})

    with open('state.txt', 'w') as outfile:
        json.dump(data, outfile)


def peering(command):
    """peering between azure and aws"""
    with open('state.txt') as json_file:
        data = json.load(json_file)

    peering = {
        'state': command,
    }
    data['processedData'].update({'peering': peering})

    with open('state.txt', 'w') as outfile:
        json.dump(data, outfile)


def spoke_vpc_state(command):
    """state update transit helper function"""
    with open('state.txt') as json_file:
        data_spoke = json.load(json_file)

        ec2SpokeVpc = {
            'state': command,
        }
        data_spoke['processedData'].update({'ec2SpokeVpc': ec2SpokeVpc})

        with open('state.txt', 'w') as outfile:
            json.dump(data_spoke, outfile)


def check_mode():
    """checking saved mode"""
    with open('state.txt', 'r') as state_file:
        data = json.load(state_file)
    if data['is_advance']:
        return True
    else:
        return False


def status_json(statename, status, state, error=None, progress=None):
    """saving responce to file for last action performed"""
    # checking if file exist
    try:
        with open('state.txt') as state_file:
            data = json.load(state_file)

        if data:
            data["stateName"] = statename
            data["status"] = status
            data["state"] = state
            data["error"] = error
            data["progress"] = progress

    except FileNotFoundError:
        data = {
            'stateName': statename,
            'status': status,
            'state': state,
            'error': error,
            'progress': progress,
        }

    with open('state.txt', 'w') as outfile:
        json.dump(data, outfile)


def mode_selection(key):
    """selection saving of mode"""
    data = {'is_advance': key}
    with open('state.txt', 'w') as outfile:
        json.dump(data, outfile)


def aws_configuration_process(key_id, secret_key):
    """Step one (aws configuration settings)"""

    # getting previous state from file
    status_json('awsConfiguration', 'in-progress', 1)

    with open('state.txt') as json_file:
        data = json.load(json_file)

    data['processedData'] = {}

    awsConfiguration = {
        'key_id': key_id,
        'secret_key': secret_key,
    }
    data['processedData'] = {'awsConfigurations': awsConfiguration}

    with open('state.txt', 'w') as outfile:
        json.dump(data, outfile)

    command = ['bash', '-c', '. /root/kickstart_web.sh;'
                             ' aws_configure ' + key_id + ' ' + secret_key]

    stateName = 'awsConfiguration'
    state = 1
    proccess(command, state, stateName)


def launch_controller(controller_data):
    """Step two (launch controller )"""
    # keeping state of control launcher
    saved_mode = check_mode()
    if saved_mode:
        controller_file_change(controller_data)
    email = controller_data.get('email')
    recovery_email = controller_data.get('recovery_email')
    password = controller_data.get('password')
    confirm_password = controller_data.get('confirm_password')

    with open('state.txt') as json_file:
        data = json.load(json_file)

    controller = {
        'email': email,
        'recovery_email': recovery_email,
        'password': password,
        'confirm_password': confirm_password,
    }

    data['processedData'].update({'controller': controller})

    with open('state.txt', 'w') as outfile:
        json.dump(data, outfile)
    # change status
    command = ['bash', '-c', '. /root/kickstart_web.sh;'
                             ' launch_controller '
               + email + ' ' + recovery_email + ' '
               + password + ' ' + confirm_password]
    state = 2
    stateName = 'launchController'
    proccess(command, state, stateName)


def launch_transit(data, command):
    """Step three (launch transit )"""
    stored_state = 3
    status_json('launchAwsTransit', 'in-progress', stored_state, None, None)
    with open('state.txt') as json_file:
        data_transit = json.load(json_file)

    try:
        aws_state_check = data_transit["processedData"]["launchAviatrixTransit"]["state"]

        if aws_state_check == 'no':
            stored_state = data_transit['state']
    except KeyError:
        pass

    if command == 'yes':
        saved_mode = check_mode()
        if saved_mode:
            mcna_file_change_aws(data)
        command_proc = ['bash', '-c', '. /root/kickstart_web.sh;'
                                      ' launch_aws_transit ' + command]

        state = stored_state
        stateName = 'launchAwsTransit'
        code_return = proccess(command_proc, state, stateName)
        if code_return == 0:
            launch_transit_state(command)
    elif command == 'no':
        status_json('skipAwsTransit', 'success', stored_state, None, None)
        launch_transit_state(command)


def launch_aws_vpc(key):
    """Step four (aws spoke vpc launch)"""
    stored_state = 4
    skip_case_state = 5
    command = None
    status_json('ec2SpokeVpc', 'in-progress', stored_state, None, None)
    with open('state.txt') as json_file:
        data = json.load(json_file)

    try:
        aws_state = data["processedData"]["ec2SpokeVpc"]["state"]

        if aws_state == 'no':
            stored_state = data['state']
    except KeyError:
        pass

    if key is True:
        command = None
    elif key is False:
        command = 'no'

    ec2SpokeVpc = {
        'state': command,
    }
    data['processedData'].update({'ec2SpokeVpc': ec2SpokeVpc})

    with open('state.txt', 'w') as outfile:
        json.dump(data, outfile)

    if key is True:
        with open('state.txt') as state_file:
            data = json.load(state_file)

        data["launchAwsSpoke"] = key

        with open('state.txt', 'w') as outfile:
            json.dump(data, outfile)

        status_json('launchAwsVpc', 'success', stored_state)

    elif key is False:
        status_json('skipSpokeVPC', 'success', skip_case_state)


def aws_spoke_vpc(keyname):
    """Step five (aws spoke vpc keypair)"""
    stored_state = 5
    with open('state.txt') as json_file:
        data = json.load(json_file)

    try:
        aws_state = data["processedData"]["ec2SpokeVpc"]["state"]

        if aws_state == 'no':
            stored_state = data['state']

    except KeyError:
        pass

    status_json('spokeVPC', 'in-progress', stored_state)
    with subprocess.Popen(
            ['bash', '-c', '. /root/kickstart_web.sh;'
                           ' mcna_aws_test_instances ' + keyname],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, bufsize=1,
            universal_newlines=True) as proc_vpc:

        previous_lines = list()
        progress = []
        for line in proc_vpc.stdout:
            previous_lines.append(output_conversion_byline(line))
            progress = ''.join(previous_lines[-30:])
            status_json('spokeVPC', 'in-progress', stored_state, None, progress)
            print(progress, end='')

        exit_code = proc_vpc.wait()
        print(exit_code)
        output = proc_vpc.communicate()
        if exit_code != 0:
            erros = error_conversion(output[1])
            status_json('spokeVPC', 'failed', stored_state, erros, progress)
            spoke_vpc_state('no')
        else:
            start = re.escape("test_ec2_instances_private_ips")
            end = re.escape("}")
            ips_string = progress
            print(progress)
            regex = re.compile('%s(.*)%s' % (start, end), re.DOTALL)
            ips = re.search(regex, ips_string).group(0)
            ips_array = re.findall(r'\d+\.\d+\.\d+\.\d+', ips)

            ips_obj = {
                'privateSpokeVm1': ips_array[0], 'privateSpokeVm2': ips_array[1],
                'publicSpokeVm1': ips_array[2], 'publicSpokeVm2': ips_array[3]
            }

            with open('state.txt') as state_file:
                data = json.load(state_file)
                data["ipsString"] = ips
                data["ips"] = ips_obj
                with open('state.txt', 'w') as outfile:
                    json.dump(data, outfile)
            status_json('spokeVPC', 'success', stored_state, None, progress)
            spoke_vpc_state('yes')

    # with open('state.txt', 'w') as outfile:
    #     json.dump(data, outfile)


def launch_transit_azure(keys_data):
    """Step six (launch transit )"""
    stored_state = 6
    saved_mode = check_mode()
    if saved_mode:
        mcna_file_change_azure(keys_data)
    azure_subscription_id = keys_data.get("azure_subscription_id", None)
    azure_directory_id = keys_data.get("azure_directory_id", None)
    azure_application_id = keys_data.get("azure_application_id", None)
    azure_application_key = keys_data.get("azure_application_key", None)

    with open('state.txt') as json_file:
        data = json.load(json_file)

    try:
        aws_state = data["processedData"]["avaitrixTransitAzure"]["state"]

        if aws_state == 'no':
            stored_state = data['state']
    except KeyError:
        pass

    command = ['bash', '-c', '. /root/kickstart_web.sh;'
                             ' launch_azure_transit ' +
               azure_subscription_id + ' ' + azure_directory_id + ' ' +
               azure_application_id + ' ' + azure_application_key]
    state = stored_state
    stateName = 'launchAzureTransit'
    code_return = proccess(command, state, stateName)
    if code_return == 0:
        launch_azure_state('yes')


def skip_azure_transit(command):
    """skip azure transit """
    status_json('skipAzureTransit', 'in-progress', 6, None, None)
    if command is True:
        command = 'no'
        launch_azure_state(command)
        peering(command)

    get_controller_ip()


def aws_azure_peering(command):
    """Peering between aws and  azure"""
    if command == 'yes':
        command_bash = ['bash', '-c', '. /root/kickstart_web.sh;'
                                      ' transit_peering_aws_azure ' + command]
        state = 7
        stateName = 'peering'
        return_code = proccess(command_bash, state, stateName)
        if return_code == 0:
            peering(command)
        # getting ip after whole proccess
        get_controller_ip()

    elif command == 'no':
        get_controller_ip()
        peering(command)


def delete_resources():
    """delete resource created """

    command = ['bash', '-c', '. /root/kickstart_web.sh;'
                             ' delete_terraform ']

    state = 0
    stateName = 'deleteResources'
    proccess(command, state, stateName)

    try:
        os.remove('state.txt')
    except OSError:  # if file not found means file dosen't exist
        pass
    status_json('deleteResources', 'success', 0)


def get_controller_ip(command=None):
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
