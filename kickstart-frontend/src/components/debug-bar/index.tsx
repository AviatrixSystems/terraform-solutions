import React, { useCallback } from "react";
// import { useDispatch } from "react-redux";

import { Button, Paragraph } from "components/base";

interface ComponentProps {
  stepNo: number;
}

export default function DebugBar(props: ComponentProps) {
  const { stepNo } = props;
  // const dispatch = useDispatch();

  const onDelete = useCallback(() => {}, []);

  return (
    <nav className="debug-bar">
      <Paragraph
        text="Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        customClasses="--dark --small"
      />
      <Button
        disabled={stepNo === 1}
        variant="outlined"
        customClasses="--blue"
        onClick={onDelete}
      >
        Delete
      </Button>
    </nav>
  );
}
