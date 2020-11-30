import React from "react";
import { useSelector } from "react-redux";

import { Heading, Paragraph, Input } from "components/base";
import { AppState } from "store";
import { copyIcon } from "svgs";
import { copyToClipboard } from "utils";

export default function Success() {
  const { controllerIP = "" } = useSelector<
    AppState,
    AppState["configuration"]
  >((state) => state.configuration);

  return (
    <div className="success-page">
      <Heading text={"Success!"} customClasses="--success-title" />
      <Paragraph
        customClasses="--light-without-opacity "
        text="Kickstart is completed. Copy the IP address to and paste it into the web
browser to access the Controller. Be sure you have it so you can use it later."
      />
      <div className="copy-to-clipborad-container">
        <label className="controller-label" htmlFor="controller-ip">
          Controller IP
        </label>
        <Input
          disabled
          id="controller-ip"
          value={controllerIP}
          variant="filled"
          InputProps={{
            endAdornment: copyIcon(() => {
              controllerIP &&
                copyToClipboard(`https://${controllerIP}`, "root");
            }),
          }}
        />
      </div>
    </div>
  );
}
