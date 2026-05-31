import asyncio

async def step1():
    print("Running Step 1")
    await asyncio.sleep(2)
    print("Step 1 is done")

async def step2():
    print("Running Step 2")
    await asyncio.sleep(3)
    print("Step 2 is done")

async def main():
    await asyncio.gather(
        step1(),
        step2()
    )

asyncio.run(main())