--Ojamachine Yellow
--  By Shad3

local scard=c511005030

function scard.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetOperation(scard.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetOperation(scard.des_op)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end

function scard.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local n=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return n>0 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then n=1 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,n,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,n,0,0)
end

function scard.op(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if n<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then n=1 end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,511005031,0xf,0x4011,0,1000,3,RACE_MACHINE,ATTRIBUTE_LIGHT) then return end
	local g=Group.CreateGroup()
	for i=1,n do
		local token=Duel.CreateToken(tp,511005031)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1)
			g:AddCard(token)
		end
	end
	Duel.SpecialSummonComplete()
	g:KeepAlive()
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(scard.tdes_cd)
	e2:SetOperation(scard.tdes_op)
	e2:SetLabelObject(g)
	Duel.RegisterEffect(e2,tp)
end

function scard.tdes_fil(c,g)
	return g:IsContains(c)
end

function scard.tdes_cd(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if eg:IsExists(scard.tdes_fil,1,nil,g) then
		return true
	elseif not g:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE) then
		g:DeleteGroup()
		e:Reset()
	end
	return false
end

function scard.tdes_op(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tc=eg:GetFirst()
	while tc do
		if g:IsContains(tc) then
			Duel.Damage(1-tc:GetPreviousControler(),300,REASON_EFFECT)
			g:RemoveCard(tc)
		end
		tc=eg:GetNext()
	end
end

function scard.des_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-e:GetHandler():GetPreviousControler(),300,REASON_EFFECT)
end