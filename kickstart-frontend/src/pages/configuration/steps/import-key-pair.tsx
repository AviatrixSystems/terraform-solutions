import React, { useCallback } from "react";
import { Formik } from "formik";
import { useDispatch } from "react-redux";

import { launchSpokevpc } from "store/actions/configuration";
import { FORM_CONFIGS } from "utils/constants";
import { Button, Heading, Paragraph, Input } from "components/base";

export default function ImportKeyPair() {
  const {
    import_key_pair: { initialValues, validations },
  } = FORM_CONFIGS;
  const dispatch = useDispatch();
  const onSubmit = useCallback(
    (values) => {
      dispatch(launchSpokevpc({ keyname: values.key_pair_name }));
    },
    [dispatch]
  );

  return (
    <Formik
      initialValues={initialValues}
      onSubmit={onSubmit}
      validationSchema={validations}
    >
      {({ values, handleChange, handleSubmit, errors }) => (
        <form onSubmit={handleSubmit} className="import-key-pair-grid">
          <div className="text-block">
            <Heading customClasses="--dark" text="Import Key Pair"></Heading>
            <Paragraph
              customClasses="--light"
              text="Enter Amazon EC2 Key Pair Name"
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
          />

          <span>
            <Button type="submit" variant="contained" customClasses=" --blue">
              Import and Continue
            </Button>
          </span>
        </form>
      )}
    </Formik>
  );
}
