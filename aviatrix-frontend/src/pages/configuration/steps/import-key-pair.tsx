import React, { useCallback } from "react";
import { Formik } from "formik";
import { useDispatch } from "react-redux";

import { setMachineState } from "store/actions/configuration";
import { FORM_CONFIGS } from "utils/constants";
import { Button, Heading, Paragraph, Input } from "components/base";

export default function ImportKeyPair() {
  const {
    import_key_pair: { initialValues, validations },
  } = FORM_CONFIGS;
  const dispatch = useDispatch();
  const onSubmit = useCallback(() => {
    dispatch(setMachineState({ step: 6, isInProgress: false }));
  }, [dispatch]);

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
              text="Lorem Ipsum is simply dummy text of the printing and typesetting industry.
                Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"
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
              Continue
            </Button>
          </span>
        </form>
      )}
    </Formik>
  );
}
