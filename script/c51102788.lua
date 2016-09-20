--Quiz Panel - Ra 30
os = require('os')
function c51102788.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(51102781,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetOperation(c51102788.operation)
	c:RegisterEffect(e1)
end
function c51102788.filter(c,g)
	local tc=g:GetFirst()
	while tc do
		if c:IsCode(tc:GetCode()) then return true end
		tc=g:GetNext()
	end
	return false
end
function c51102788.operation(e,tp,eg,ep,ev,re,r,rp)
	local endtime=0
	local check=true
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,3,nil)
	local ct=Duel.GetMatchingGroupCount(c51102788.filter,tp,0x13,0,nil,g)
	local start=os.time()
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(51102788,0))
	local tc=Duel.AnnounceNumber(1-tp,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,
		44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,
		93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120)
	endtime=os.time()-start
	if endtime>10 or tc~=ct then
		check=false
	end
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	if check==true then
		Duel.Damage(tp,500,REASON_EFFECT)
	else
		if Duel.GetAttacker() then
			Duel.Destroy(Duel.GetAttacker(),REASON_EFFECT)
		end
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end
