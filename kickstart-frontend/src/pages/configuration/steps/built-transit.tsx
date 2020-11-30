import React, { useCallback } from "react";
import { useDispatch } from "react-redux";

import { Button, Heading, Paragraph } from "components/base";
import { builtTransit } from "store/actions/configuration";

export default function BuiltTransit() {
  const dispatch = useDispatch();
  const onSubmit = useCallback(() => {
    dispatch(builtTransit({ command: true }));
  }, [dispatch]);

  return (
    <div className="built-transit-grid">
      <div className="text-block">
        <Heading
          customClasses="--dark"
          text="Built Transit Peering between AWS & Azure"
        ></Heading>
        <Paragraph
          customClasses="--light"
          text="Do you want to build a transit peering between AWS and Azure?"
        ></Paragraph>
      </div>
      <span>
        <Button variant="contained" customClasses="--blue" onClick={onSubmit}>
          Yes
        </Button>
        <Button variant="outlined" customClasses="--blue">
          No
        </Button>
      </span>
    </div>
  );
}
