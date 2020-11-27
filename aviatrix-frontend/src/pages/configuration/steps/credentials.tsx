import React, { useCallback } from "react";
import { Formik } from "formik";
import { useDispatch } from "react-redux";

import { setMachineState } from "store/actions/configuration";
import { Input, Button, Heading, Paragraph } from "components/base";
import { FORM_CONFIGS } from "utils/constants";

export default function Credentials() {
  const dispatch = useDispatch();
  const {
    credentials_form: { initialValues, validations },
  } = FORM_CONFIGS;
  const onSubmit = useCallback(() => {
    dispatch(setMachineState({ step: 2, isInProgress: false }));
  }, [dispatch]);

  return (
    <Formik
      initialValues={initialValues}
      onSubmit={onSubmit}
      validationSchema={validations}
    >
      {({ values, handleChange, handleSubmit, errors }) => (
        <form onSubmit={handleSubmit} className="credential-form-grid">
          <div className="text-block">
            <Heading customClasses="--dark" text="AWS Credentials"></Heading>
            <Paragraph
              customClasses="--light"
              text="These can be obtained from AWS Console under my security credentials"
            ></Paragraph>
          </div>
          <Input
            error={Boolean(errors.access_key_id)}
            value={values.access_key_id}
            name="access_key_id"
            label="Access Key ID"
            variant="outlined"
            customClasses="--standard --blue"
            onChange={handleChange}
            helperText={errors.access_key_id}
          />
          <Input
            value={values.secret_access_key}
            name="secret_access_key"
            label="Secret Access Key"
            variant="outlined"
            customClasses="--standard --blue"
            onChange={handleChange}
            error={Boolean(errors.secret_access_key)}
            helperText={errors.secret_access_key}
          />
          <span>
            <Button type="submit" variant="contained" customClasses="--blue">
              Continue
            </Button>
          </span>
        </form>
      )}
    </Formik>
  );
}
