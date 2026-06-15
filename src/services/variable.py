import repository.variable_repository as variable_repo


async def delete_stale_variables():
    stale_vars = await variable_repo.get_stale_variables()
    if (len(stale_vars) > 0):
        for v in stale_vars:
            await variable_repo.delete(v['id'])
