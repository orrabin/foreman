import React from 'react';
import {FormGroup, ControlLabel, FormControl, HelpBlock } from 'react-bootstrap';
import './Input.css';

const Input = ({
  id = Date.now(),
  label,
  value,
  type = 'text',
  srOnly = true,
  placeholder,
  valueChanged,
  valueValidation,
  validator
}) => {

  return (
      <FormGroup className="form-inline"
        controlId={id + label} validationState={validator} >

        <ControlLabel srOnly={srOnly}>{label}</ControlLabel>
        <FormControl
          type={type}
          onChange={valueChanged}
          value={value}
          placeholder={placeholder}
        />
        <HelpBlock>{valueValidation}</HelpBlock>
      </FormGroup>
  );
};

export default Input;
