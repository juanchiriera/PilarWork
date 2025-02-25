import { Create, SimpleForm, TextInput, NumberInput, SelectArrayInput, useNotify, useRedirect, required } from 'react-admin';
import { useGetList } from 'react-admin';

export const PrecioCreate = () => {
    const notify = useNotify();
    const redirect = useRedirect();

    const { data: espacios, isLoading } = useGetList('espacios', {
        pagination: { page: 1, perPage: 100 }
    });

    const handleSubmit = async (data: any) => {
        try {
            await fetch('http://localhost:3000/api/precios', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    ...data,
                    valor: Number(data.valor),
                    espacios: data.espacios || []
                }),
            });

            notify('Precio creado exitosamente', { type: 'success' });
            redirect('/precios');
        } catch (error) {
            notify('Error al crear el precio', { type: 'error' });
        }
    };

    return (
        <Create title="Crear Nuevo Precio">
            <SimpleForm onSubmit={handleSubmit} sanitizeEmptyValues>
                <TextInput
                    source="medida"
                    label="Medida (hora/día/mes)"
                    validate={required()}
                    fullWidth
                />

                <NumberInput
                    source="valor"
                    label="Valor"
                    validate={required()}
                    min={0}
                    step={100}
                    fullWidth
                />

                <SelectArrayInput
                    source="espacios"
                    label="Espacios aplicables"
                    choices={espacios || []}
                    optionText="name"
                    optionValue="id"
                    validate={required()}
                    isLoading={isLoading}
                    fullWidth
                />
            </SimpleForm>
        </Create>
    );
};