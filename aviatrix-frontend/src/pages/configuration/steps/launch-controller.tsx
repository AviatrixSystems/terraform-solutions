import React, { useCallback, useState } from "react";
import { FormControlLabel } from "@material-ui/core";
import { Formik } from "formik";
import { useDispatch } from "react-redux";

import { Input, Button, Checkbox, Heading, Paragraph } from "components/base";
import { FORM_CONFIGS } from "utils/constants";
import { setMachineState } from "store/actions/configuration";

interface StepsProps {
  setStep: React.Dispatch<React.SetStateAction<number>>;
}

function StepOne(props: StepsProps) {
  const { setStep } = props;
  const proceedToNext = useCallback(() => {
    setStep(1);
  }, []);

  return (
    <div className="launch-controller-grid">
      <div className="text-block">
        <Heading customClasses="--dark" text="Controller"></Heading>
        <Paragraph
          customClasses="--light"
          text="The public IP of the controller will be shared with the Aviatrix for tracking
          purposes. Also, the controller will be launched in US-East-1"
        ></Paragraph>
      </div>
      <span>
        <Button
          variant="contained"
          customClasses="--blue"
          onClick={proceedToNext}
        >
          Yes
        </Button>
        <Button
          variant="outlined"
          customClasses="--blue"
          onClick={proceedToNext}
        >
          No
        </Button>
      </span>
    </div>
  );
}

function StepTwo(props: StepsProps) {
  const { setStep } = props;
  const proceedToNext = useCallback(() => {
    setStep(2);
  }, []);
  const proceedToBack = useCallback(() => {
    setStep(0);
  }, []);

  return (
    <div className="launch-controller-grid">
      <div className="text-block">
        <Heading customClasses="--dark" text="Controller"></Heading>
        <Paragraph
          customClasses="--light"
          text="Do you want to Subscribe to Aviatrix controller?"
        ></Paragraph>
      </div>
      <div>
        <FormControlLabel
          control={<Checkbox customClasses="--blue" />}
          label={
            <Paragraph
              customClasses="--light-without-opacity --small"
              text={
                <span>
                  I understand all <a href="#">terms & conditions</a>
                </span>
              }
            />
          }
        />
      </div>
      <span>
        <Button
          variant="contained"
          customClasses="--blue"
          onClick={proceedToNext}
        >
          Confirm
        </Button>
        <Button
          variant="outlined"
          customClasses="--blue"
          onClick={proceedToBack}
        >
          Cancel
        </Button>
      </span>
    </div>
  );
}

function StepThree() {
  const dispatch = useDispatch();
  const {
    launch_controller: { initialValues, validations },
  } = FORM_CONFIGS;
  const onSubmit = useCallback(() => {
    dispatch(setMachineState({ step: 3, isInProgress: false }));
  }, [dispatch]);

  return (
    <Formik
      initialValues={initialValues}
      onSubmit={onSubmit}
      validationSchema={validations}
    >
      {({ values, handleChange, handleSubmit, errors }) => (
        <form onSubmit={handleSubmit} className="launch-controller-grid">
          <div className="text-block">
            <Heading customClasses="--dark" text="Controller"></Heading>
            <Paragraph
              customClasses="--light"
              text="The public IP of the controller will be shared with the Aviatrix for tracking
          purposes. Also, the controller will be launched in US-East-1"
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
            value={values.re_enter_password}
            name="re_enter_password"
            label="Re-enter Password"
            fullWidth={false}
            variant="outlined"
            customClasses="--small --blue"
            onChange={handleChange}
            error={Boolean(errors.re_enter_password)}
            helperText={errors.re_enter_password}
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

export default function LaunchController() {
  const [step, setStep] = useState(0);

  switch (step) {
    case 0:
      return <StepOne setStep={setStep} />;
    case 1:
      return <StepTwo setStep={setStep} />;
    case 2:
      return <StepThree />;
    default:
      return <StepOne setStep={setStep} />;
  }
}
