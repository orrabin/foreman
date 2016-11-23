import React from 'react';
import {FormGroup, ControlLabel, FormControl, Button} from 'react-bootstrap';

const Parameter = ({name, value, id = Date.now(), type = 'text', nameChanged, valueChanged}) => {

  const validator = (context) => {
    return (name.length > 1 ? 'success' : 'warning');
  };

  return (
    <div className="form-inline">
      <FormGroup
        controlId={id + 'Name'}
        validationState={validator()} >

        <ControlLabel srOnly={true}>Name</ControlLabel>
        <FormControl
          type="text"
          onChange={nameChanged}
          value={name}
          placeholder="Name"
        />
      </FormGroup>

      <FormGroup controlId={id + 'Value'}>
        <ControlLabel srOnly={true}>Value</ControlLabel>
        <FormControl
          type={type}
          onChange={valueChanged}
          value={value}
          placeholder="Value"
         />
      </FormGroup>

      <Button type="submit">
      Send invitation
      </Button>
    </div>
  );
};

export default Parameter;
