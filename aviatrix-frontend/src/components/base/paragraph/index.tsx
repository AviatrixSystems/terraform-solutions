import React from "react";
import { CustomClasses } from "types";

interface ComponentProps extends CustomClasses {
  text: React.ReactNode;
}

export default function Paragraph({
  text,
  customClasses = "",
}: ComponentProps) {
  return <p className={`paragraph ${customClasses}`}>{text}</p>;
}
