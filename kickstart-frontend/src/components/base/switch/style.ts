import { withStyles } from "@material-ui/core/styles";
import { Switch as MaterialSwitch } from "@material-ui/core";

export const AntSwitch = withStyles((theme) => ({
  root: {
    width: 39,
    height: 20,
    padding: 0,
    display: "flex",
  },
  switchBase: {
    padding: 2,
    color: theme.palette.grey[500],
    "&$checked": {
      transform: "translateX(18px)",
      color: theme.palette.common.white,
      "& + $track": {
        opacity: 1,
        backgroundColor: "#4287f5",
        borderColor: "#4287f5",
      },
    },
  },
  thumb: {
    width: 16,
    height: 16,
    boxShadow: "none",
    background: "#fff",
  },
  track: {
    border: `1px solid #4287f5`,
    borderRadius: 20 / 2,
    opacity: 1,
    backgroundColor: "#4287f5",
  },
  checked: {},
}))(MaterialSwitch);
