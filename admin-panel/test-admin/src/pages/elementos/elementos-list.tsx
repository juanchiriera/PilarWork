import { List, Datagrid, TextField, NumberField, BooleanField } from 'react-admin';

const elementosList = () => (
<List perPage={10}>
        <Datagrid>
            <TextField source="name" /> 
            <NumberField source="quantity" />
            <BooleanField source="available" />
        </Datagrid>
    </List>
);

export default elementosList;