import { List, Datagrid, TextField, NumberField } from 'react-admin';

const precioList = () => (
<List perPage={10}>
        <Datagrid>
            <TextField source="medida" />
            <NumberField source="valor" />
        </Datagrid>
    </List>
);

export default precioList;