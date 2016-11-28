import React from 'react';
import {FormGroup, ControlLabel, FormControl } from 'react-bootstrap';

const Input = ({
  id = Date.now(),
  label,
  value,
  type = 'text',
  srOnly = true,
  placeholder,
  valueChanged
}) => {

  return (
      <FormGroup
        controlId={id + label} >

        <ControlLabel srOnly={srOnly}>{label}</ControlLabel>
        <FormControl
          type={type}
          onChange={valueChanged}
          value={value}
          placeholder={placeholder}
        />
      </FormGroup>
  );
};

export default Input;
