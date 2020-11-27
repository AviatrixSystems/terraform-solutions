import React from "react";

import { Button, Paragraph } from "components/base";

export default function DebugBar() {
  return (
    <nav className="debug-bar">
      <Paragraph
        text="Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        customClasses="--dark --small"
      />
      <Button variant="outlined" customClasses="--blue">
        Delete
      </Button>
    </nav>
  );
}
