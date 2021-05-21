import React, { useCallback } from "react";
import { useDispatch } from "react-redux";

import { Button, Heading, Paragraph } from "components/base";
import { setMachineState } from "store/actions/configuration";

export default function BuiltTransit() {
  const dispatch = useDispatch();
  const onSubmit = useCallback(() => {
    dispatch(setMachineState({ step: 8, isInProgress: false }));
  }, [dispatch]);

  return (
    <div className="built-transit-grid">
      <div className="text-block">
        <Heading
          customClasses="--dark"
          text="Build Transit Peering between AWS & Azure"
        ></Heading>
        <Paragraph
          customClasses="--light"
          text="Lorem Ipsum is simply dummy text of the printing and typesetting industry.
          Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"
        ></Paragraph>
      </div>
      <span>
        <Button variant="contained" customClasses="--blue" onClick={onSubmit}>
          Yes
        </Button>
        <Button variant="outlined" customClasses="--blue" onClick={onSubmit}>
          No
        </Button>
      </span>
    </div>
  );
}
