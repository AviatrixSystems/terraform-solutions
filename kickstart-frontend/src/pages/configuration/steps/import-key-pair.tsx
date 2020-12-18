import React, { useCallback } from "react";
import { Formik } from "formik";
import { useDispatch, useSelector } from "react-redux";
import { useHistory } from "react-router-dom";

import { launchSpokevpc } from "store/actions/configuration";
import { FORM_CONFIGS } from "utils/constants";
import { Button, Heading, Paragraph, Input } from "components/base";
import { AppState } from "store";

export default function ImportKeyPair() {
  const {
    import_key_pair: { initialValues, validations },
  } = FORM_CONFIGS;
  const dispatch = useDispatch();
  const history = useHistory();
  const {
    step,
    processedData: { ec2SpokeVpc },
  } = useSelector<AppState, AppState["configuration"]>(
    (state) => state.configuration
  );
  const onSubmit = useCallback(
    (values) => {
      dispatch(launchSpokevpc({ keyname: values.key_pair_name }, history));
    },
    [dispatch, history]
  );
  const pageDisabled = step > 5 && ec2SpokeVpc?.state !== null;

  return (
    <Formik
      initialValues={initialValues}
      onSubmit={onSubmit}
      validationSchema={validations}
    >
      {({ values, handleChange, handleSubmit, errors }) => (
        <form onSubmit={handleSubmit} className="import-key-pair-grid">
          <div className="text-block">
            <Heading customClasses="--dark" text="Key Pair Name"></Heading>
            <Paragraph
              customClasses="--light"
              text="Enter Amazon EC2 Key Pair Name (make sure your key pair name is correct). This is your own key pair, not Aviatrix keys for controller or gateways. Also make sure you are in the region where the Spoke gateways were launched (if using defaults, us-east-2)."
            ></Paragraph>
          </div>
          <Input
            error={Boolean(errors.key_pair_name)}
            value={values.key_pair_name}
            name="key_pair_name"
            label="Name"
            variant="outlined"
            fullWidth={false}
            customClasses="--small --blue"
            onChange={handleChange}
            helperText={errors.key_pair_name}
            disabled={pageDisabled}
          />

          <span>
            <Button
              disabled={pageDisabled}
              type="submit"
              variant="contained"
              customClasses=" --blue"
            >
              Import and Continue
            </Button>
          </span>
        </form>
      )}
    </Formik>
  );
}
