--coded by Lyris
--Flash Fang
function c511007006.initial_effect(c)
	--All "Shark" monsters you currently control gain 500 ATK, until the End Phase.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511007006.target)
	e1:SetOperation(c511007006.activate)
	c:RegisterEffect(e1)
end
--"Shark" monsters
function c511007006.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x321)
end
function c511007006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511007006.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c511007006.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetCard(g)
end
function c511007006.filter2(c,e)
	return c:IsFaceup() and c:IsSetCard(0x321) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function c511007006.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c511007006.filter2,tp,LOCATION_MZONE,0,nil,e)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(511007006,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_DAMAGE)
		e2:SetOperation(c511007006.regcon)
		tc:RegisterEffect(e2)
		tc=sg:GetNext()
	end
	sg:KeepAlive()
	--At the end of this turn's Battle Phase, if a monster(s) affected by this effect has inflicted battle damage to your opponent by a direct attack: You can destroy all monsters your opponent controls with a lower ATK than the damage inflicted.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetReset(RESET_PHASE+PHASE_BATTLE)
	e2:SetRange(0xff)
	e2:SetCountLimit(1)
	e2:SetLabel(fid)
	e2:SetLabelObject(sg)
	e2:SetCondition(c511007006.descon)
	e2:SetOperation(c511007006.desop)
	c:RegisterEffect(e2)
end
--record opponent's inflicted battle damage
function c511007006.regcon(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp and Duel.GetAttackTarget()==nil then
		local c=e:GetHandler()
		c:SetFlagEffectLabel(511007006,c:GetFlagEffectLabel(511007006)+ev)
	end
end
--monsters that inflicted battle damage to opponent
function c511007006.desfilter(c,fid)
	return c:GetFlagEffectLabel(511007006)-fid>0
end
--monsters with less ATK than damage inflicted
function c511007006.desopfilter(c,dam)
	return c:GetAttack()<dam and c:IsDestructable()
end
function c511007006.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local fid=e:GetLabel()
	local dg=g:Filter(c511007006.desfilter,nil,fid)
	if dg:GetCount()~=0 then
		local dam=0
		local tc=dg:GetFirst()
		while tc do
			dam=dam+(tc:GetFlagEffectLabel(511007006)-fid)
			tc=dg:GetNext()
		end
		return Duel.IsExistingMatchingCard(c511007006.desopfilter,tp,0,LOCATION_MZONE,1,nil,dam)
	else
		g:DeleteGroup()
		e:Reset()
		return false
	end
end
function c511007006.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local fid=e:GetLabel()
	local dg=g:Filter(c511007006.desfilter,nil,fid)
	g:DeleteGroup()
	--destroy all monsters your opponent controls with a lower ATK than the damage inflicted
	local dam=0
	local tc=dg:GetFirst()
	while tc do
		dam=dam+(tc:GetFlagEffectLabel(511007006)-fid)
		tc=dg:GetNext()
	end
	local sg=Duel.GetMatchingGroup(c511007006.desopfilter,tp,0,LOCATION_MZONE,nil,dam)
	Duel.Destroy(sg,REASON_EFFECT)
end
