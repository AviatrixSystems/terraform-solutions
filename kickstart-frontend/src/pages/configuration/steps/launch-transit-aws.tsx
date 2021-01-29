import React, { useCallback, useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { useHistory } from "react-router-dom";
import { Formik } from "formik";

import { launchTransit, sendVariableCall } from "store/actions/configuration";
import { Button, Heading, Paragraph, Input, Separator } from "components/base";
import { AppState } from "store";
import { FORM_CONFIGS } from "utils/constants";

const {
  launch_transit_aws: { validations },
} = FORM_CONFIGS;

export default function LaunchTransitAWS() {
  const [awsResponse, setAwsResponse] = useState<Boolean>();

  const dispatch = useDispatch();

  const history = useHistory();

  const {
    is_advance,
    step,
    step3_variables,
    processedData: { launchAviatrixTransit } = {},
  } = useSelector<AppState, AppState["configuration"]>(
    (state) => state.configuration
  );
  const onYes = useCallback(() => {
    setAwsResponse(true);
    if (!is_advance) {
      dispatch(launchTransit({ command: true }, history));
    }
  }, [dispatch, history, is_advance]);

  const onNo = useCallback(() => {
    setAwsResponse(false);
    dispatch(launchTransit({ command: false }, history));
  }, [dispatch, history]);

  const pageDisabled = step > 3 && launchAviatrixTransit?.state !== "no";

  useEffect(() => {
    dispatch(sendVariableCall("step3_variables", history));
  }, [dispatch, history]);

  return step3_variables ? (
    <Formik
      initialValues={step3_variables}
      onSubmit={(data) => {
        dispatch(launchTransit({ command: true, ...data }, history));
      }}
      validationSchema={validations}
    >
      {({ values, handleChange, handleSubmit, errors }) => (
        <form className="launch-transit-aws-grid" onSubmit={handleSubmit}>
          <div className="text-block">
            <Heading
              customClasses="--dark"
              text="Launch Aviatrix Transit in AWS"
            ></Heading>
            <Paragraph
              customClasses="--light"
              text={
                !is_advance ? (
                  <span>
                    Do you want to launch the Aviatrix transit in AWS? Region
                    will be us-east-2. Go to{" "}
                    <a href="https://raw.githubusercontent.com/AviatrixSystems/terraform-solutions/master/solutions/img/kickstart.png">
                      https://raw.githubusercontent.com/AviatrixSystems/terraform-solutions/master/solutions/img/kickstart.png
                    </a>{" "}
                    to view what is going to be launched.
                  </span>
                ) : (
                  <span>
                    Do you want to launch the Aviatrix transit in AWS? Go to
                    <a href="https://raw.githubusercontent.com/AviatrixSystems/terraform-solutions/master/solutions/img/kickstart.png">
                      https://raw.githubusercontent.com/AviatrixSystems/terraform-solutions/master/solutions/img/kickstart.png
                    </a>
                    to view what is going to be launched. You can change the
                    settings in the next step.
                  </span>
                )
              }
            ></Paragraph>
          </div>
          {awsResponse === undefined && (
            <span>
              <Button
                disabled={pageDisabled}
                variant="contained"
                customClasses="--blue"
                onClick={onYes}
              >
                Yes
              </Button>
              <Button
                disabled={pageDisabled}
                variant="outlined"
                customClasses="--blue"
                onClick={onNo}
              >
                No
              </Button>
            </span>
          )}
          {awsResponse && is_advance && (
            <>
              <Input
                value={values.aws_region}
                name="aws_region"
                label="Aws Region"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.aws_region)}
                helperText={errors.aws_region}
                disabled={pageDisabled}
              />
              <Separator />
              <Heading
                customClasses="--dark --sub-heading"
                text="AWS Transit VPCs"
              />
              <Input
                value={values.aws_transit_vpc_name}
                name="aws_transit_vpc_name"
                label="Name"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.aws_transit_vpc_name)}
                helperText={errors.aws_transit_vpc_name}
                disabled={pageDisabled}
              />
              <Input
                value={values.aws_transit_vpc_cidr}
                name="aws_transit_vpc_cidr"
                label="CIDR"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.aws_transit_vpc_cidr)}
                helperText={errors.aws_transit_vpc_cidr}
                disabled={pageDisabled}
              />
              <Separator />
              <Heading
                customClasses="--dark --sub-heading"
                text="AWS Spoke1 VPC"
              />
              <Input
                value={values.aws_spoke1_vpc_name}
                name="aws_spoke1_vpc_name"
                label="Name"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.aws_spoke1_vpc_name)}
                helperText={errors.aws_spoke1_vpc_name}
                disabled={pageDisabled}
              />
              <Input
                value={values.aws_spoke1_vpc_cidr}
                name="aws_spoke1_vpc_cidr"
                label="CIDR"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.aws_spoke1_vpc_cidr)}
                helperText={errors.aws_spoke1_vpc_cidr}
                disabled={pageDisabled}
              />
              <Separator />
              <Heading
                customClasses="--dark --sub-heading"
                text="AWS Spoke2 VPC"
              />
              <Input
                value={values.aws_spoke2_vpc_name}
                name="aws_spoke2_vpc_name"
                label="Name"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.aws_spoke2_vpc_name)}
                helperText={errors.aws_spoke2_vpc_name}
                disabled={pageDisabled}
              />
              <Input
                value={values.aws_spoke2_vpc_cidr}
                name="aws_spoke2_vpc_cidr"
                label="CIDR"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.aws_spoke2_vpc_cidr)}
                helperText={errors.aws_spoke2_vpc_cidr}
                disabled={pageDisabled}
              />
              <Separator />
              <Heading
                customClasses="--dark --sub-heading"
                text="AWS Transit Gateway"
              />
              <Input
                value={values.aws_transit_gateway_name}
                name="aws_transit_gateway_name"
                label="Name"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.aws_transit_gateway_name)}
                helperText={errors.aws_transit_gateway_name}
                disabled={pageDisabled}
              />
              <Separator />
              <Heading
                customClasses="--dark --sub-heading"
                text="AWS Spoke Gateways"
              />
              <Input
                value={values.aws_spoke1_gateways_name}
                name="aws_spoke1_gateways_name"
                label="Spoke1 Name"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.aws_spoke1_gateways_name)}
                helperText={errors.aws_spoke1_gateways_name}
                disabled={pageDisabled}
              />
              <Input
                value={values.aws_spoke2_gateways_name}
                name="aws_spoke2_gateways_name"
                label="Spoke2 Name"
                variant="outlined"
                customClasses="--standard --blue --small"
                onChange={handleChange}
                error={Boolean(errors.aws_spoke2_gateways_name)}
                helperText={errors.aws_spoke2_gateways_name}
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
            </>
          )}
        </form>
      )}
    </Formik>
  ) : (
    <div />
  );
}
