import React, { useCallback } from "react";
import { useSelector } from "react-redux";

import { Heading, Paragraph, Input, Button } from "components/base";
import { AppState } from "store";
import { copyToClipboard } from "utils";

export default function Success() {
  const { controllerIP = "", ips } = useSelector<
    AppState,
    AppState["configuration"]
  >((state) => state.configuration);
  const onCopy = useCallback((ip: string) => {
    copyToClipboard(ip, "root");
  }, []);

  return (
    <div className="success-page">
      <Heading text={"Success!"} customClasses="--success-title" />
      <Paragraph
        customClasses="--light-without-opacity "
        text={
          <span>
            Sandbox Starter is completed successfully. Access the below link to open
            the controller: <br />
            <a
              target="blank"
              href={`https://${controllerIP}`}
            >{`https://${controllerIP}`}</a>
          </span>
        }
      />
      {ips && (
        <>
          <div className="ip-section">
            <Heading text={"Private IPs"} customClasses="--dark" />
            <div className="copy-to-clipborad-container">
              <label className="controller-label" htmlFor="privateSpokeVm1">
                Spoke1-VM
              </label>
              <Input
                disabled
                id="privateSpokeVm1"
                value={ips?.privateSpokeVm1}
                variant="filled"
                InputProps={{
                  endAdornment: (
                    <Button
                      variant="contained"
                      customClasses="--blue"
                      onClick={() => onCopy(ips?.privateSpokeVm1 || "")}
                    >
                      Copy
                    </Button>
                  ),
                }}
              />
            </div>
            <div className="copy-to-clipborad-container">
              <label className="controller-label" htmlFor="privateSpokeVm2">
                Spoke2-VM
              </label>
              <Input
                disabled
                id="privateSpokeVm2"
                value={ips?.privateSpokeVm2}
                variant="filled"
                InputProps={{
                  endAdornment: (
                    <Button
                      variant="contained"
                      customClasses="--blue"
                      onClick={() => onCopy(ips?.privateSpokeVm2 || "")}
                    >
                      Copy
                    </Button>
                  ),
                }}
              />
            </div>
          </div>

          <div className="ip-section">
            <Heading text={"Public IPs"} customClasses="--dark" />
            <div className="copy-to-clipborad-container">
              <label className="controller-label" htmlFor="publicSpokeVm1">
                Spoke1-VM
              </label>
              <Input
                disabled
                id="publicSpokeVm1"
                value={ips.publicSpokeVm1}
                variant="filled"
                InputProps={{
                  endAdornment: (
                    <Button
                      variant="contained"
                      customClasses="--blue"
                      onClick={() => onCopy(ips?.publicSpokeVm1 || "")}
                    >
                      Copy
                    </Button>
                  ),
                }}
              />
            </div>
            <div className="copy-to-clipborad-container">
              <label className="controller-label" htmlFor="publicSpokeVm2">
                Spoke2-VM
              </label>
              <Input
                disabled
                id="publicSpokeVm2"
                value={ips?.publicSpokeVm2}
                variant="filled"
                InputProps={{
                  endAdornment: (
                    <Button
                      variant="contained"
                      customClasses="--blue"
                      onClick={() => onCopy(ips?.publicSpokeVm2 || "")}
                    >
                      Copy
                    </Button>
                  ),
                }}
              />
            </div>
          </div>
        </>
      )}
    </div>
  );
}
