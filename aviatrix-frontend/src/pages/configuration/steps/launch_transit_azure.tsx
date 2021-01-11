import React, { useCallback, useState } from "react";
import { Formik } from "formik";
import { useDispatch } from "react-redux";

import { Button, Heading, Paragraph, Input } from "components/base";
import { FORM_CONFIGS } from "utils/constants";
import { setMachineState } from "store/actions/configuration";

export default function LaunchTransitAzure() {
  const {
    launch_transit_azure: { initialValues, validations },
  } = FORM_CONFIGS;
  const dispatch = useDispatch();
  const [azureResponse, setAzureResponse] = useState<Boolean>();

  const handlePositiveResponse = useCallback(() => {
    setAzureResponse(true);
  }, []);

  const handleNegativeResponse = useCallback(() => {
    setAzureResponse(false);
  }, []);

  const onSubmit = useCallback(() => {
    dispatch(setMachineState({ step: 7, isInProgress: false }));
  }, [dispatch]);

  return (
    <Formik
      initialValues={initialValues}
      onSubmit={onSubmit}
      validationSchema={validations}
    >
      {({ values, handleChange, handleSubmit, errors }) => (
        <form className="launch-transit-azure-grid" onSubmit={handleSubmit}>
          <div className="text-block">
            <Heading
              customClasses="--dark"
              text="Launch Aviatrix Transit in Azure"
            ></Heading>
            <Paragraph
              customClasses="--light"
              text="Lorem Ipsum is simply dummy text of the printing and typesetting industry.
          Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"
            ></Paragraph>
          </div>
          <span className="btn-group">
            <Button
              variant="contained"
              customClasses="--blue"
              onClick={handlePositiveResponse}
            >
              Yes
            </Button>
            <Button
              variant="outlined"
              customClasses="--blue"
              onClick={handleNegativeResponse}
            >
              No
            </Button>
          </span>
          {azureResponse && (
            <div className="form-fields">
              <Input
                value={values.subscription_id}
                name="subscription_id"
                label="Subscription ID"
                variant="outlined"
                customClasses="--standard --blue"
                onChange={handleChange}
                error={Boolean(errors.subscription_id)}
                helperText={errors.subscription_id}
              />
              <Input
                value={values.directory_id}
                name="directory_id"
                label="Directory ID"
                variant="outlined"
                customClasses="--standard --blue"
                onChange={handleChange}
                error={Boolean(errors.directory_id)}
                helperText={errors.directory_id}
              />
              <Input
                value={values.application_id}
                name="application_id"
                label="Application ID"
                variant="outlined"
                customClasses="--standard --blue"
                onChange={handleChange}
                error={Boolean(errors.application_id)}
                helperText={errors.application_id}
              />
              <Input
                value={values.application_key}
                name="application_key"
                label="Application Key"
                variant="outlined"
                customClasses="--standard --blue"
                onChange={handleChange}
                error={Boolean(errors.application_key)}
                helperText={errors.application_key}
              />
              <span className="btn-submit">
                <Button
                  type="submit"
                  variant="contained"
                  customClasses=" --blue"
                >
                  Continue
                </Button>
              </span>
            </div>
          )}
        </form>
      )}
    </Formik>
  );
}
