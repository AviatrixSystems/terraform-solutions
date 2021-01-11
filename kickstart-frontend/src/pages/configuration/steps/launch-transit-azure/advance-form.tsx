import React, { Dispatch, useCallback, useEffect, useState } from "react";
import { Formik } from "formik";

import { Button, Heading, Paragraph, Input, Separator } from "components/base";
import { FORM_CONFIGS } from "utils/constants";
import {
  launchTransitAzure,
  sendVariableCall,
  skipTransitAzure,
} from "store/actions/configuration";
import { ConfigurationState } from "types/store";

interface ComponentProps {
  processedData: ConfigurationState["processedData"];
  step6_variables: ConfigurationState["step6_variables"];
  pageDisabled: boolean;
  history: any;
  dispatch: Dispatch<any>;
}

export default function AdvanceForm(props: ComponentProps) {
  const {
    launch_transit_azure: { initialValuesAdvance, validationsAdvance },
  } = FORM_CONFIGS;
  const { dispatch, history, pageDisabled, step6_variables } = props;
  const [azureResponse, setAzureResponse] = useState<Boolean>();

  const handlePositiveResponse = useCallback(() => {
    setAzureResponse(true);
  }, []);

  const handleNegativeResponse = useCallback(() => {
    setAzureResponse(false);
    dispatch(skipTransitAzure({ command: true }, history));
  }, [dispatch, history]);

  const onSubmit = useCallback(
    (values) => {
      dispatch(launchTransitAzure(values, history));
    },
    [dispatch, history]
  );

  const inputValues: typeof initialValuesAdvance = {
    ...initialValuesAdvance,
    azure_region: step6_variables?.azure_region || "",
    azure_vnets_name: step6_variables?.azure_vnets_name || "",
    azure_vnets_name_cidr: step6_variables?.azure_vnets_name_cidr || "",
    azure_spoke1_vnet_name: step6_variables?.azure_spoke1_vnet_name || "",
    azure_spoke1_vnet_cidr: step6_variables?.azure_spoke1_vnet_cidr || "",
    azure_spoke2_vnet_name: step6_variables?.azure_spoke2_vnet_name || "",
    azure_spoke2_vnet_cidr: step6_variables?.azure_spoke2_vnet_cidr || "",
    azure_transit_gateway: step6_variables?.azure_transit_gateway || "",
    azure_spoke1_gateways_name:
      step6_variables?.azure_spoke1_gateways_name || "",
    azure_spoke2_gateways_name:
      step6_variables?.azure_spoke2_gateways_name || "",
  };

  useEffect(() => {
    dispatch(sendVariableCall("step6_variables", history));
  }, [dispatch, history]);

  return step6_variables ? (
    <Formik
      initialValues={inputValues}
      onSubmit={onSubmit}
      validationSchema={validationsAdvance}
    >
      {({ values, handleChange, handleSubmit, errors }) => (
        <form className="launch-transit-azure-grid" onSubmit={handleSubmit}>
          <div className="text-block">
            <Heading
              customClasses="--dark"
              text="Launch Aviatrix Transit in Azure"
            />
            <Paragraph
              customClasses="--light"
              text={
                azureResponse === undefined ? (
                  "Do you want to launch the Aviatrix transit in Azure?"
                ) : (
                  <span>
                    Enter your Azure API keys for the Azure deployment. Perform
                    the pre-requisites at{" "}
                    <a
                      target="blank"
                      href="https://docs.aviatrix.com/HowTos/Aviatrix_Account_Azure.html"
                    >
                      https://docs.aviatrix.com/HowTos/Aviatrix_Account_Azure.html
                    </a>
                  </span>
                )
              }
            />
          </div>
          {azureResponse === undefined && (
            <span className="btn-group">
              <Button
                variant="contained"
                customClasses="--blue"
                onClick={handlePositiveResponse}
                disabled={pageDisabled}
              >
                Yes
              </Button>
              <Button
                variant="outlined"
                customClasses="--blue"
                onClick={handleNegativeResponse}
                disabled={pageDisabled}
              >
                No
              </Button>
            </span>
          )}
          {azureResponse && (
            <div className="form-fields">
              <Input
                value={values.azure_subscription_id}
                name="azure_subscription_id"
                label="Subscription ID"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.azure_subscription_id)}
                helperText={errors.azure_subscription_id}
                disabled={pageDisabled}
              />
              <Input
                value={values.azure_directory_id}
                name="azure_directory_id"
                label="Directory ID"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.azure_directory_id)}
                helperText={errors.azure_directory_id}
                disabled={pageDisabled}
              />
              <Input
                value={values.azure_application_id}
                name="azure_application_id"
                label="Application ID"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.azure_application_id)}
                helperText={errors.azure_application_id}
                disabled={pageDisabled}
              />
              <Input
                value={values.azure_application_key}
                name="azure_application_key"
                label="Application Key"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.azure_application_key)}
                helperText={errors.azure_application_key}
                disabled={pageDisabled}
              />
              <Input
                value={values.azure_region}
                name="azure_region"
                label="Azure Region"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.azure_region)}
                helperText={errors.azure_region}
                disabled={pageDisabled}
              />
              <Separator />
              <Heading
                customClasses="--dark --sub-heading"
                text=" Azure Transit VNet"
              />
              <Input
                value={values.azure_vnets_name}
                name="azure_vnets_name"
                label="Name"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.azure_vnets_name)}
                helperText={errors.azure_vnets_name}
                disabled={pageDisabled}
              />
              <Input
                value={values.azure_vnets_name_cidr}
                name="azure_vnets_name_cidr"
                label="CIDR"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.azure_vnets_name_cidr)}
                helperText={errors.azure_vnets_name_cidr}
                disabled={pageDisabled}
              />
              <Separator />
              <Heading
                customClasses="--dark --sub-heading"
                text="Azure Spoke1 VNet"
              />
              <Input
                value={values.azure_spoke1_vnet_name}
                name="azure_spoke1_vnet_name"
                label="Name"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.azure_spoke1_vnet_name)}
                helperText={errors.azure_spoke1_vnet_name}
                disabled={pageDisabled}
              />
              <Input
                value={values.azure_spoke1_vnet_cidr}
                name="azure_spoke1_vnet_cidr"
                label="CIDR"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.azure_spoke1_vnet_cidr)}
                helperText={errors.azure_spoke1_vnet_cidr}
                disabled={pageDisabled}
              />
              <Separator />
              <Heading
                customClasses="--dark --sub-heading"
                text="Azure Spoke2 VNet"
              />
              <Input
                value={values.azure_spoke2_vnet_name}
                name="azure_spoke2_vnet_name"
                label="Name"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.azure_spoke2_vnet_name)}
                helperText={errors.azure_spoke2_vnet_name}
                disabled={pageDisabled}
              />
              <Input
                value={values.azure_spoke2_vnet_cidr}
                name="azure_spoke2_vnet_cidr"
                label="CIDR"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.azure_spoke2_vnet_cidr)}
                helperText={errors.azure_spoke2_vnet_cidr}
                disabled={pageDisabled}
              />
              <Separator />
              <Heading
                customClasses="--dark --sub-heading"
                text="Azure Transit Gateway"
              />
              <Input
                value={values.azure_transit_gateway}
                name="azure_transit_gateway"
                label="Name"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.azure_transit_gateway)}
                helperText={errors.azure_transit_gateway}
                disabled={pageDisabled}
              />
              <Separator />
              <Heading
                customClasses="--dark --sub-heading"
                text="Azure Spoke Gateways"
              />
              <Input
                value={values.azure_spoke1_gateways_name}
                name="azure_spoke1_gateways_name"
                label="Spoke1 Name"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.azure_spoke1_gateways_name)}
                helperText={errors.azure_spoke1_gateways_name}
                disabled={pageDisabled}
              />
              <Input
                value={values.azure_spoke2_gateways_name}
                name="azure_spoke2_gateways_name"
                label="Spoke2 Name"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.azure_spoke2_gateways_name)}
                helperText={errors.azure_spoke2_gateways_name}
                disabled={pageDisabled}
              />
              <span className="btn-submit">
                <Button
                  type="submit"
                  variant="contained"
                  customClasses=" --blue"
                  disabled={pageDisabled}
                >
                  Continue
                </Button>
              </span>
            </div>
          )}
        </form>
      )}
    </Formik>
  ) : (
    <div />
  );
}
