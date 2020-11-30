import React from "react";

import { Paragraph } from "components/base";
import { CircularProgress } from "@material-ui/core";

export default function LoadingBar() {
  return (
    <div className="loading-screen">
      {/* <div className="loading-bar">
        <div className="__inner" />
      </div> */}
      <div className="blank-wrapper">
        <div className="text-wrapper">
          <CircularProgress />
          <Paragraph text="Processing" customClasses="--dark" />
          <Paragraph text="Please wait, this step might take several minutes..." />
        </div>
      </div>
    </div>
  );
}
