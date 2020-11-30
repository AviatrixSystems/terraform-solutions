import React, { useCallback, useState } from "react";
import { Formik } from "formik";
import { useDispatch } from "react-redux";

import { Input, Button, Heading, Paragraph } from "components/base";
import { FORM_CONFIGS } from "utils/constants";
import { launchController } from "store/actions/configuration";

export default function LaunchController() {
  const dispatch = useDispatch();
  const {
    launch_controller: { initialValues, validations },
  } = FORM_CONFIGS;
  const onSubmit = useCallback(
    (values) => {
      dispatch(
        launchController({
          email: values.email_address,
          recovery_email: values.recovery_email_address,
          password: values.password,
          confirm_password: values.re_enter_password,
        })
      );
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
        <form onSubmit={handleSubmit} className="launch-controller-grid">
          <div className="text-block">
            <Heading customClasses="--dark" text="Launch Controller"></Heading>
            <Paragraph
              customClasses="--light"
              text={
                <span>
                  <a
                    target="blank"
                    href="https://aws.amazon.com/marketplace/pp?sku=b03hn7ck7yp392plmk8bet56k"
                  >
                    Subscribe
                  </a>{" "}
                  Subscribe to Aviatrix platform on AWS marketplace. Also, the
                  controller will be launched in us-east-1 region.
                </span>
              }
            ></Paragraph>
          </div>
          <Input
            value={values.email_address}
            name="email_address"
            label="Email Address"
            variant="outlined"
            fullWidth={false}
            customClasses="--small --blue"
            onChange={handleChange}
            error={Boolean(errors.email_address)}
            helperText={errors.email_address}
          />
          <Input
            value={values.recovery_email_address}
            name="recovery_email_address"
            label="Recovery Email Address"
            variant="outlined"
            fullWidth={false}
            customClasses="--small --blue"
            onChange={handleChange}
            error={Boolean(errors.recovery_email_address)}
            helperText={errors.recovery_email_address}
          />
          <Input
            type="password"
            value={values.password}
            name="password"
            label="Password"
            variant="outlined"
            fullWidth={false}
            customClasses="--small --blue"
            onChange={handleChange}
            error={Boolean(errors.password)}
            helperText={errors.password}
          />
          <Input
            type="password"
            value={values.re_enter_password}
            name="re_enter_password"
            label="Re-enter Password"
            fullWidth={false}
            variant="outlined"
            customClasses="--small --blue"
            onChange={handleChange}
            error={
              values.password !== values.re_enter_password ||
              Boolean(errors.re_enter_password)
            }
            helperText={
              values.password !== values.re_enter_password
                ? "Password is not same"
                : errors.re_enter_password
            }
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
